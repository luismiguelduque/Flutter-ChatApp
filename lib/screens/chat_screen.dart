import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _isWriting = false;
  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              backgroundColor: Colors.blue[100],
              child: Text("TE", style: TextStyle(fontSize: 12),),
            ),
            SizedBox(
              height: 3,
            ),
            Text("Test 1", style: TextStyle(color: Colors.black87, fontSize: 12),),
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
      uid: "123",
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    this._textController.clear();
    this._focusNode.requestFocus();
    setState(() {
      _isWriting = false;
    });
  }

  @override
  void dispose() {
    for(ChatMessage message in _messages ){
      message.animationController.dispose();
    }
    super.dispose();
  }
}