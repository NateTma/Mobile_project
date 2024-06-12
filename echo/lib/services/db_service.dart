/**import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/contact.dart';
import '../models/conversation.dart';
import '../models/message.dart';

class DBService {
  static DBService instance = DBService();

  Firestore _db;

  DBService() {
    _db = Firestore.instance;
  }

  String _userCollection = "Users";
  String _conversationsCollection = "Conversations";

  Future<void> createUserInDB(
      String _uid, String _name, String _email, String _imageURL) async {
    try {
      return await _db.collection(_userCollection).document(_uid).setData({
        "name": _name,
        "email": _email,
        "image": _imageURL,
        "lastSeen": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserLastSeenTime(String _userID) {
    var _ref = _db.collection(_userCollection).document(_userID);
    return _ref.updateData({"lastSeen": Timestamp.now()});
  }

  Future<void> sendMessage(String _conversationID, Message _message) {
    var _ref =
        _db.collection(_conversationsCollection).document(_conversationID);
    var _messageType = "";
    switch (_message.type) {
      case MessageType.Text:
        _messageType = "text";
        break;
      case MessageType.Image:
        _messageType = "image";
        break;
      default:
    }
    return _ref.updateData({
      "messages": FieldValue.arrayUnion(
        [
          {
            "message": _message.content,
            "senderID": _message.senderID,
            "timestamp": _message.timestamp,
            "type": _messageType,
          },
        ],
      ),
    });
  }

  Future<void> createOrGetConversartion(String _currentID, String _recepientID,
      Future<void> _onSuccess(String _conversationID)) async {
    var _ref = _db.collection(_conversationsCollection);
    var _userConversationRef = _db
        .collection(_userCollection)
        .document(_currentID)
        .collection(_conversationsCollection);
    try {
      var conversation =
          await _userConversationRef.document(_recepientID).get();
      if (conversation.data != null) {
        return _onSuccess(conversation.data["conversationID"]);
      } else {
        var _conversationRef = _ref.document();
        await _conversationRef.setData(
          {
            "members": [_currentID, _recepientID],
            "ownerID": _currentID,
            'messages': [],
          },
        );
        return _onSuccess(_conversationRef.documentID);
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<Contact> getUserData(String _userID) {
    var _ref = _db.collection(_userCollection).document(_userID);
    return _ref.get().asStream().map((_snapshot) {
      return Contact.fromFirestore(_snapshot);
    });
  }

  Stream<List<ConversationSnippet>> getUserConversations(String _userID) {
    var _ref = _db
        .collection(_userCollection)
        .document(_userID)
        .collection(_conversationsCollection);
    return _ref.snapshots().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return ConversationSnippet.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream<List<Contact>> getUsersInDB(String _searchName) {
    var _ref = _db
        .collection(_userCollection)
        .where("name", isGreaterThanOrEqualTo: _searchName)
        .where("name", isLessThan: _searchName + 'z');
    return _ref.getDocuments().asStream().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return Contact.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream<Conversation> getConversation(String _conversationID) {
    var _ref =
        _db.collection(_conversationsCollection).document(_conversationID);
    return _ref.snapshots().map(
      (_doc) {
        return Conversation.fromFirestore(_doc);
      },
    );
  }
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contact.dart';
import '../models/conversation.dart';
import '../models/message.dart';

class DBService {
  static final DBService instance = DBService._();

  DBService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String _userCollection = "Users";
  final String _conversationsCollection = "Conversations";

  Future<void> createUserInDB(String uid, String name, String email, String imageURL) async {
    try {
      return await _db.collection(_userCollection).doc(uid).set({
        "name": name,
        "email": email,
        "image": imageURL,
        "lastSeen": Timestamp.now().toDate(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserLastSeenTime(String userID) {
    var ref = _db.collection(_userCollection).doc(userID);
    return ref.update({"lastSeen": Timestamp.now()});
  }

  Future<void> sendMessage(String conversationID, Message message) {
    var ref = _db.collection(_conversationsCollection).doc(conversationID);
    var messageType = "";
    switch (message.type) {
      case MessageType.Text:
        messageType = "text";
        break;
      case MessageType.Image:
        messageType = "image";
        break;
      default:
    }
    return ref.update({
      "messages": FieldValue.arrayUnion(
        [
          {
            "message": message.content,
            "senderID": message.senderID,
            "timestamp": message.timestamp,
            "type": messageType,
          },
        ],
      ),
    });
  }

  Future<void> createOrGetConversation(
      String currentID, String recipientID, Function(String) onSuccess) async {
    var ref = _db.collection(_conversationsCollection);
    var userConversationRef = _db.collection(_userCollection).doc(currentID).collection(_conversationsCollection);
    try {
      var conversation = await userConversationRef.doc(recipientID).get();
      if (conversation.exists) {
        return onSuccess(conversation.data()?["conversationID"]);
      } else {
        var conversationRef = ref.doc();
        await conversationRef.set({
          "members": [currentID, recipientID],
          "ownerID": currentID,
          'messages': [],
        });
        return onSuccess(conversationRef.id);
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<Contact> getUserData(String userID) {
    var ref = _db.collection(_userCollection).doc(userID);
    return ref.snapshots().map((snapshot) {
      return Contact.fromFirestore(snapshot);
    });
  }

  Stream<List<ConversationSnippet>> getUserConversations(String userID) {
    var ref = _db.collection(_userCollection).doc(userID).collection(_conversationsCollection);
    return ref.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ConversationSnippet.fromFirestore(doc);
      }).toList();
    });
  }

  Stream<List<Contact>> getUsersInDB(String searchName) {
    var ref = _db
        .collection(_userCollection)
        .where("name", isGreaterThanOrEqualTo: searchName)
        .where("name", isLessThan: searchName + 'z');
    return ref.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Contact.fromFirestore(doc);
      }).toList();
    });
  }

  Stream<Conversation> getConversation(String conversationID) {
    var ref = _db.collection(_conversationsCollection).doc(conversationID);
    return ref.snapshots().map(
      (doc) {
        return Conversation.fromFirestore(doc);
      },
    );
  }
}