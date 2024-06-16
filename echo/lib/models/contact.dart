import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String id;
  final String email;
  final String image;
  final Timestamp? lastseen;
  final String name;

  Contact({
    required this.id, 
    required this.email, 
    required this.name, 
    required this.image, 
    required this.lastseen});

  factory Contact.fromFirestore(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Contact(
      id: snapshot.id, //updated to id instead of documentiID
      lastseen: data["lastSeen"],
      email: data["email"],
      name: data["name"],
      image: data["image"],
    );
  }
}