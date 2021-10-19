import 'dart:convert';

MessagesResponse messagesResponseFromJson(String str) => MessagesResponse.fromJson(json.decode(str));

String messagesResponseToJson(MessagesResponse data) => json.encode(data.toJson());

class MessagesResponse {
  MessagesResponse({
    required this.ok,
    required this.messages,
  });

  bool ok;
  List<Message>? messages;

  factory MessagesResponse.fromJson(Map<String, dynamic> json) => MessagesResponse(
    ok: json["ok"] == null ? null : json["ok"],
    messages: json["messages"] == null ? null : List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok == null ? null : ok,
    "messages": messages == null ? null : List<dynamic>.from(messages!.map((x) => x.toJson())),
  };
}

class Message {
  Message({
    required this.from,
    required this.to,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  String from;
  String to;
  String message;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    from: json["from"] == null ? null : json["from"],
    to: json["to"] == null ? null : json["to"],
    message: json["message"] == null ? null : json["message"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "from": from == null ? null : from,
    "to": to == null ? null : to,
    "message": message == null ? null : message,
    "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
    "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}
