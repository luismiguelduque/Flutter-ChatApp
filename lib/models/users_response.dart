import 'dart:convert';

import 'package:flutter_chat_app/models/user.dart';

UsersResponse usersResponseFromJson(String str) => UsersResponse.fromJson(json.decode(str));

String usersResponseToJson(UsersResponse data) => json.encode(data.toJson());

class UsersResponse {
  UsersResponse({
    required this.ok,
    required this.users,
  });

  bool ok;
  List<User>? users;

  factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
    ok: json["ok"] ?? false,
    users: json["users"] == null ? null : List<User>.from(json["users"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok == null ? null : ok,
    "users": List<dynamic>.from(users!.map((x) => x.toJson())),
  };
}

