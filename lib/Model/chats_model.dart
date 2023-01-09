import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  Timestamp? created;
  String? image;
  String? message;
  String? messageId;
  String? messageType;
  String? receiver;
  String? sender;
  String? id;
  String? createdOn;

  ChatModel({
    this.created,
    this.image,
    this.message,
    this.messageId,
    this.messageType,
    this.receiver,
    this.sender,
    this.createdOn,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    created = json['created'];
    image = json['image'];
    message = json['message'];
    messageId = json['messageId'];
    messageType = json['messageType'];
    receiver = json['receiver'];
    sender = json['sender'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created'] = created;
    data['image'] = image;
    data['message'] = message;
    data['messageId'] = messageId;
    data['messageType'] = messageType;
    data['receiver'] = receiver;
    data['sender'] = sender;
    data['createdOn'] = createdOn;
    return data;
  }
}
