import 'package:canary_chat/widgets/search_widget.dart';
import 'package:canary_chat/widgets/chat_room_list.dart';
import 'package:canary_chat/widgets/contact_list.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Tin nhắn",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchWidget()),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          const Flexible(
            flex: 1,
            child: ContactList(),
          ),
          Flexible(
            flex: 5,
            child: ChatRoomList(),
          ),
        ],
      ),
    );
  }
}
