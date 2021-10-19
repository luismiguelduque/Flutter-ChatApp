import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../services/auth_service.dart';
import '../services/socket_service.dart';
import '../services/users_service.dart';
import '../services/chat_service.dart';
import '../models/user.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {

  final userService = UsersService();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<User> users = [];

  @override
  void initState() {
    this._loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final User user = authService.user;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${user.name}", style: TextStyle(color: Colors.black54),),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, "login");
            AuthService.deleteToken();
          },
          icon: Icon(Icons.exit_to_app, color: Colors.black54,),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online 
              ? Icon(Icons.check_circle, color: Colors.blue[400],)
              : Icon(Icons.offline_bolt, color: Colors.red,)
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400],),
          waterDropColor: Colors.blue,
        ),
        onRefresh: _loadUsers,
        child: UsersList(users: users),
      ),
    );
  }

  void _loadUsers() async{
    this.users = (await this.userService.getUsers(0))!;
    setState(() {});
    _refreshController.refreshCompleted();
  }
}

class UsersList extends StatelessWidget {
  const UsersList({
    Key? key,
    required this.users,
  }) : super(key: key);

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => UserTile(user: users[i]), 
      separatorBuilder: (_, i) => Divider(),
      itemCount: users.length
    );
  }
}

class UserTile extends StatelessWidget {
  const UserTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${user.name}"),
      subtitle: Text("${user.email}"),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text("${user.name.substring(0,2)}"),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: user.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      onTap: (){
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userTo = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }
}
