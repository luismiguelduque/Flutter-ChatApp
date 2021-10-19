import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../global/enviroment.dart';
import '../models/messages_response.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class ChatService with ChangeNotifier {

  late User userTo;

  Future<List<Message>?> getChatMessages(String userId) async {
    try{
      final token = await AuthService.getToken();
      final resp = await http.get(
        Uri.parse('${Enviroment.apiUrl}/messages/$userId'),
        headers: {
          'Content-Type': 'applecation/json',
          'x-token': "$token",
        }
      );
      final messagesResponse = messagesResponseFromJson(resp.body);
      return messagesResponse.messages;
    }catch(e){
      return [];
    }
  }

}