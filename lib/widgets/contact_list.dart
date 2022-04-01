import 'package:canary_chat/models/user_data.dart';
import 'package:canary_chat/services/auth_service.dart';
import 'package:canary_chat/services/firestore_service.dart';
import 'package:canary_chat/widgets/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final _scrollController = ScrollController();
  final _firestore = FireStoreService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.getUserName(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _contactList(context, snapshot.data!.docs)
              : Container();
        });
  }

  Widget _contactList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return ListView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.only(top: 16.0),
      children:
          snapshot!.map((data) => _contactListItem(context, data)).toList(),
    );
  }

  Widget _contactListItem(BuildContext context, DocumentSnapshot snapshot) {
    final user = UserData.fromSnapshot(snapshot);
    return contactTile(user.name!, user.email!);
  }

  Widget contactTile(String name, String email) {
    final roomId = roomID(email, AuthService().currentEmail()!);

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ChatRoom(name: name, email: email)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.pink,
              child: Text(name[0].toUpperCase()),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: Text(name, style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  List roomID(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return [a, b];
    }
    return [b, a];
  }
}
