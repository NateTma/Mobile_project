import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';

class ConversationSnippet {
  final String id;
  final String conversationID;
  final String lastMessage;
  final String name;
  final String image;
  final MessageType type;
  final int unseenCount;
  final Timestamp timestamp;

  ConversationSnippet({
    required this.conversationID,
    required this.id,
    required this.lastMessage,
    required this.unseenCount,
    required this.timestamp,
    required this.name,
    required this.image,
    required this.type
    });

  factory ConversationSnippet.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data as Map<String, dynamic>;
    var _messageType = MessageType.Text;
    if (_data["type"] != null) {
      switch (_data["type"]) {
        case "text":
          break;
        case "image":
          _messageType = MessageType.Image;
          break;
        default:
      }
    }
    return ConversationSnippet(
      id: _snapshot.id,
      conversationID: _data["conversationID"],
      lastMessage: _data["lastMessage"] != null ? _data["lastMessage"] : "",
      unseenCount: _data["unseenCount"],
      timestamp: _data["timestamp"] != null ? _data["timestamp"] : Timestamp.now(),
      name: _data["name"],
      image: _data["image"],
      type: _messageType,
    );
  }
}

class Conversation {
  final String id;
  final List members;
  final List<Message> messages;
  final String ownerID;

  Conversation({
    required this.id, 
    required this.members, 
    required this.ownerID, 
    required this.messages});

  factory Conversation.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data as Map<String, dynamic>;
    List<Message> _messages = [];
    if (_data["messages"] != null) {
      _messages = (_data["messages"] as List<dynamic>).map(
        (_m) {
          return Message(
              type: _m["type"] == "text" ? MessageType.Text : MessageType.Image,
              content: _m["message"],
              timestamp: _m["timestamp"],
              senderID: _m["senderID"]);
        },
      ).toList();
    } else {
      _messages = [];
    }
    return Conversation(
        id: _snapshot.id, //updated to id instead of documentID here as well
        members: List<String>.from(_data["members"]),
        ownerID: _data["ownerID"],
        messages: _messages
        );
  }
}