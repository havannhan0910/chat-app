import 'package:canary_chat/models/conversation.dart';
import 'package:canary_chat/models/message.dart';
import 'package:canary_chat/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreService extends ChangeNotifier {
  final _userInfo = FirebaseFirestore.instance.collection('userInfo');
  final _chatroom = FirebaseFirestore.instance.collection('chatroom');

  //Upload user data to firebase
  Future uploadUserInfo(UserData userData) async {
    return await _userInfo
        .doc(userData.userId)
        .set(userData.toMap());
  }

  Stream<QuerySnapshot> getUserName() {
    return _userInfo.snapshots();
  }

  //Search user base on username
  Future getUserByUserName(String name) async {
    return await _userInfo.where('name', isEqualTo: name).get();
  }

  Future getUserByEmail(String email) async {
    return await _userInfo.where('email', isEqualTo: email).get();
  }

  //Upload message to firebase
  saveMessage(Message message, Conversation conversation) {
    return _chatroom
        .doc(conversation.roomId.toString())
        .collection('message')
        .doc(message.date.toString())
        .set(message.toJson());
  }

  Stream<QuerySnapshot> getMessageStream(Conversation conversation) {
      return _chatroom.doc(conversation.roomId.toString()).collection(
          'message').snapshots();
  }

  Future addUSerToChatRoom(Conversation conversation) async {
    return await _chatroom
        .doc(conversation.roomId.toString())
        .set(conversation.toJson());
  }

  Stream<QuerySnapshot> addConversation() {
    return _chatroom.snapshots();
  }
}
