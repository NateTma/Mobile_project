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

  factory ConversationSnippet.fromFirestore(DocumentSnapshot snapshot) {
    var data = snapshot.data as Map<String, dynamic>;
    var messageType = MessageType.Text;
    if (data["type"] != null) {
      switch (data["type"]) {
        case "text":
          break;
        case "image":
          messageType = MessageType.Image;
          break;
        default:
      }
    }
    return ConversationSnippet(
      id: snapshot.id,
      conversationID: data["conversationID"],
      lastMessage: data["lastMessage"] ?? "",
      unseenCount: data["unseenCount"],
      timestamp: data["timestamp"] ?? Timestamp.now(),
      name: data["name"],
      image: data["image"],
      type: messageType,
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

  factory Conversation.fromFirestore(DocumentSnapshot snapshot) {
    var data = snapshot.data as Map<String, dynamic>;
    List<Message> messages = [];
    if (data["messages"] != null) {
      messages = (data["messages"] as List<dynamic>).map(
        (m) {
          return Message(
              type: m["type"] == "text" ? MessageType.Text : MessageType.Image,
              content: m["message"],
              timestamp: m["timestamp"],
              senderID: m["senderID"]);
        },
      ).toList();
    } else {
      messages = [];
    }
    return Conversation(
        id: snapshot.id, //updated to id instead of documentID here as well
        members: List<String>.from(data["members"]),
        ownerID: data["ownerID"],
        messages: messages
        );
  }
}