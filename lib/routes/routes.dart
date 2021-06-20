import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';
import '../screens/loading_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/users_screen.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'chat': (_) => ChatScreen(),
  'loading': (_) => LoadingScreen(),
  'login': (_) => LoginScreen(),
  'register': (_) => RegisterScreen(),
  'users': (_) => UsersScreen(),
};
