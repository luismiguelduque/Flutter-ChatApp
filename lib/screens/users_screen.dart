import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user_model.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {

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
      body: ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => ListTile(
          title: Text("${users[i].name}"),
          leading: CircleAvatar(
            child: Text("${users[i].name.substring(0,2)}"),
          ),
          trailing: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: users[i].online ? Colors.green[300] : Colors.red,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ), 
        separatorBuilder: (_, i) => Divider(),
        itemCount: users.length
      )
    );
  }
}
