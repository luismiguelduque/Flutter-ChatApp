
import 'package:flutter_chat_app/global/enviroment.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/models/users_response.dart';
import 'package:flutter_chat_app/services/auth_service.dart';

import 'package:http/http.dart' as http;

class UsersService {

  Future<List<User>?> getUsers(from) async {
    try{
      final token = await AuthService.getToken();
      
      final resp = await http.get(
        Uri.parse('${Enviroment.apiUrl}/users'),
        headers: {
          'Content-Type': 'applecation/json',
          'x-token': "$token",
        }
      );
      final usersResponse = usersResponseFromJson(resp.body);
      return usersResponse.users;
    }catch(e){
      return [];
    }
  }

}