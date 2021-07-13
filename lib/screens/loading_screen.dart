import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:provider/provider.dart';

import '../screens/login_screen.dart';
import '../screens/users_screen.dart';
import '../services/auth_service.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot){
          return Center(
            child: Text('Authorizing...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final authenticated = await authService.isLogedIn();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      if(authenticated){
        Navigator.pushReplacement(
          context, 
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => UsersScreen(),
            transitionDuration: Duration(milliseconds: 0)
          ),
        );
      }else{
        Navigator.pushReplacement(
          context, 
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoginScreen(),
            transitionDuration: Duration(milliseconds: 0)
          ),
        );
      }
    });
  }
}
