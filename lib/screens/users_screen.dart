import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:flutter_chat_app/models/user_model.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final List<UserModel> users = [
    UserModel(uid: "t1", name: "Luis Duque", email: "luis@email.com", online: false),
    UserModel(uid: "t2", name: "John Doe", email: "john@email.com", online: true),
    UserModel(uid: "t3", name: "Pedro Perez", email: "pedro@email.com", online: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mi nombre", style: TextStyle(color: Colors.black54),),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){},
          icon: Icon(Icons.exit_to_app, color: Colors.black54,),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: 1 == 1 
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
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}

class UsersList extends StatelessWidget {
  const UsersList({
    Key? key,
    required this.users,
  }) : super(key: key);

  final List<UserModel> users;

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

  final UserModel user;

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
    );
  }
}
