import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../global/enviroment.dart';
import '../models/user.dart';
import '../models/login_response.dart';


class AuthService with ChangeNotifier {

  late User user;
  bool _authenticating = false;
  final _storage = new FlutterSecureStorage();

  bool get authenticating => this._authenticating;
  set authenticating(bool value){
    this._authenticating = value;
    notifyListeners();
  }

  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: "token");
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    _storage.delete(key: "token");
  }

  Future<bool> login(String email, String password) async {
    final data = {
      "email": email,
      "password": password
    };

    this.authenticating = true;
    final response = await http.post(
      Uri.parse("${Enviroment.apiUrl}/login"), 
      body: jsonEncode(data),
      headers: {
        'Content-type': 'application/json'
      }
    );
    this.authenticating = false;
    if(response.statusCode == 200){
      final loginResponse = loginResponseFromJson(response.body);
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);
      return true;
    }
    return false;
  }

  Future register(String name, String email, String password) async {
    final data = {
      "name": name,
      "email": email,
      "password": password
    };

    this.authenticating = true;
    final response = await http.post(
      Uri.parse("${Enviroment.apiUrl}/login/new"), 
      body: jsonEncode(data),
      headers: {
        'Content-type': 'application/json'
      }
    );
    this.authenticating = false;
    if(response.statusCode == 200){
      final loginResponse = loginResponseFromJson(response.body);
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);
      return true;
    }
    final responseBody = jsonDecode(response.body);
    return responseBody["msg"];
  }

  Future<bool> isLogedIn() async {
    final token = await _storage.read(key: "token");
    final response = await http.get(
      Uri.parse("${Enviroment.apiUrl}/login/renew"),
      headers: {
        'Content-type': 'application/json',
        'x-token': token.toString(),
      }
    );
    if(response.statusCode == 200){
      final loginResponse = loginResponseFromJson(response.body);
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);
      return true;
    }
    this._logOut();
    return false;
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: "token", value: token);
  }

  Future _logOut() async {
    return await _storage.delete(key: "token");
  }

}