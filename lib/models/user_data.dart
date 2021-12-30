import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? userId;
  final String? name;
  final String? email;
  DocumentReference? reference;

  UserData({this.userId, this.name, this.email, this.reference,});

  factory UserData.fromJson(Map<dynamic, dynamic> json) =>
      UserData(
        name: json['name'] as String,
        email: json['email'] as String,
      );

  Map<String, dynamic> toMap() =>
      <String, dynamic>{
        'name': name,
        'email': email,
      };

  factory UserData.fromSnapshot(DocumentSnapshot snapshot) {
    final userData = UserData.fromJson(snapshot.data() as Map<String, dynamic>);
    userData.reference = snapshot.reference;
    return userData;
  }
}
