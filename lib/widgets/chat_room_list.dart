import 'package:canary_chat/models/conversation.dart';
import 'package:canary_chat/services/auth_service.dart';
import 'package:canary_chat/services/firestore_service.dart';
import 'package:canary_chat/widgets/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'conversation_widget.dart';

class ChatRoomList extends StatelessWidget {
  ChatRoomList({Key? key}) : super(key: key);

  final _scrollController = ScrollController();
  final _firestore = FireStoreService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.addConversation(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? chatRoomList(context, snapshot.data!.docs)
              : emptyList();
        },
      );
  }

  Widget emptyList() {
    return const Center(
      child: Text(
        "Chưa có tin nhắn nào",
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  Widget chatRoomList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Column(
        children: snapshot!.map((data) => chatListItem(context, data)).toList(),
      ),
    );
  }

  Widget chatListItem(BuildContext context, DocumentSnapshot snapshot) {
    final _conversation = Conversation.fromSnapshot(snapshot);

    final bool _isSender =
        _conversation.receiverEmail == AuthService().currentEmail();

    final bool _inConversation =
        _conversation.roomId!.contains(AuthService().currentEmail());

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ChatRoom(
                      name: _isSender ? _conversation.sender : _conversation.receiver,
                      email: _isSender? _conversation.senderEmail : _conversation.receiverEmail,
                    )));
      },
      child: !_inConversation ? Container() : ConversationWidget(
        receiver: _isSender ? _conversation.sender : _conversation.receiver,
        dateTime: _conversation.date,
        text: _conversation.lastMessage,
      ),
    );
  }
}
