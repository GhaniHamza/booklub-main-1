import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  String? id;
  String? lastMessage;
  Timestamp? lastMessageTime;

  ChatRoomModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lastMessage = json['lastMessage'];
    lastMessageTime = json['lastMessageTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lastMessage'] = lastMessage;
    data['lastMessageTime'] = lastMessageTime;
    return data;
  }
}
