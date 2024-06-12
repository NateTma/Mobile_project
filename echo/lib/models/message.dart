import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { Text, Image }

class Message {
  final String senderID;
  final String content;
  final Timestamp timestamp;
  final MessageType type;

  Message(
      {required this.senderID,
      required this.content,
      required this.timestamp,
      required this.type});

  factory Message.fromMap(Map<String, dynamic> data) {
    var messageType = MessageType.Text;
    switch (data['type']) {
      case 'text':
        messageType = MessageType.Text;
        break;
      case 'image':
        messageType = MessageType.Image;
        break;
    }
    return Message(
      content: data['message'],
      senderID: data['senderID'],
      timestamp: data['timestamp'],
      type: messageType
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': content,
      'senderID': senderID,
      'timestamp': timestamp,
      'type': type == MessageType.Text ? 'text' : 'image'
    };
  }
}
