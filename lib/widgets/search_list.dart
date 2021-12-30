import 'package:canary_chat/widgets/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchList extends StatelessWidget {
  QuerySnapshot searchSnapshot;

  SearchList({Key? key, required this.searchSnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: searchSnapshot.docs.length,
      itemBuilder: (context, index) {
        return searchTile(
          searchSnapshot.docs[index].get('name'),
          searchSnapshot.docs[index].get('email'),
          index,
          context,
        );
      },
    );
  }

  Widget searchTile(String name, String email, int index, BuildContext context) {
    final name = searchSnapshot.docs[index].get('name');
    final email = searchSnapshot.docs[index].get('email');

    return ListTile(
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              email,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.blue),
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatRoom(name: name, email: email)),
            );
          },
          icon: const Icon(
            Icons.message,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
