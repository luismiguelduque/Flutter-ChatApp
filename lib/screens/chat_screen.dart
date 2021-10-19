import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/models/messages_response.dart';
import 'dart:io';

import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/socket_service.dart';
import '../services/chat_service.dart';
import '../models/user.dart';
import '../widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _isWriting = false;
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('personal-message', _listenMessage);

    _loadMessages(this.chatService.userTo.uid);
  }

  void _listenMessage( dynamic payload ){
    ChatMessage message = ChatMessage(
      text: payload['message'], 
      uid: payload['from'], 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300)),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  void _loadMessages(String uid) async {
    List<Message>? chatMessages = await chatService.getChatMessages(uid);
    final messagesHistory = chatMessages!.map((m)=> ChatMessage(
      text: m.message, 
      uid: m.from, 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 0))..forward())
    ).toList();
    setState(() {
      _messages = messagesHistory;
    });
  }

  @override
  Widget build(BuildContext context) {

    final User userTo = this.chatService.userTo;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              backgroundColor: Colors.blue[100],
              child: Text("${userTo.name.substring(0,2)}", style: TextStyle(fontSize: 12),),
            ),
            SizedBox(
              height: 3,
            ),
            Text("${userTo.name}", style: TextStyle(color: Colors.black87, fontSize: 14),),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                reverse: true,
                itemBuilder: (_, i){
                  return _messages[i];
                }
              ),
            ),
            Divider(height: 1,),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: _chatTextfield(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatTextfield(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (value){
                  setState(() {
                    if(value.trim().length > 0){
                      _isWriting = true;
                    }else{
                      _isWriting = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(hintText: "Enviar mensaje"),
                focusNode: _focusNode,
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS 
                ? CupertinoButton(
                  child: Text("Enviar"), 
                  onPressed: _isWriting 
                    ? () => _handleSubmit(_textController.text.trim()) 
                    : null,
                )
                : Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: IconTheme(
                    data: IconThemeData(
                      color: Colors.blue[400],
                    ),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.send), 
                      onPressed: _isWriting 
                        ? () => _handleSubmit(_textController.text.trim()) 
                        : null,
                    ),
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text){
    if(text.length == 0) return;
    final newMessage = new ChatMessage(
      text: _textController.text, 
      uid: authService.user.uid,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    this._textController.clear();
    this._focusNode.requestFocus();
    setState(() {
      _isWriting = false;
    });
    
    this.socketService.emit('personal-message', {
      'from': this.authService.user.uid,
      'to': this.chatService.userTo.uid,
      'message': text
    });
  }

  @override
  void dispose() {
    for(ChatMessage message in _messages ){
      message.animationController.dispose();
    }
    this.socketService.socket.off('personal-message');
    super.dispose();
  }
}