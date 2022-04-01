import 'package:canary_chat/models/conversation.dart';
import 'package:canary_chat/models/message.dart';
import 'package:canary_chat/services/auth_service.dart';
import 'package:canary_chat/services/firestore_service.dart';
import 'package:canary_chat/services/notifications.dart';
import 'package:canary_chat/widgets/message_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  final String name;
  final String email;

  const ChatRoom({Key? key, required this.name, required this.email})
      : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final _txtMessage = TextEditingController();
  final _scrollController = ScrollController();
  final _auth = AuthService();

  bool _canSend() => _txtMessage.text.isNotEmpty;

  @override
  void initState() {
    // TODO: implement initState
    NotificationsAPI.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FireStoreService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.name),
            Text(
              widget.email,
              style: const TextStyle(fontSize: 10),
            )
          ],
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _getMessageList(firestore),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    maxLines: null,
                    controller: _txtMessage,
                    decoration: InputDecoration(
                      hintText: "Viết tin nhắn",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    onSubmitted: (_) {
                      _sendMessage(firestore);
                    },
                    onChanged: (_) {
                      setState(() {
                        _canSend();
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(_canSend()
                      ? Icons.send_rounded
                      : Icons.cancel_schedule_send_rounded),
                  onPressed: () {
                    setState(() {
                      !_canSend();
                      NotificationsAPI.display(
                        title: _auth.currentName(),
                        body: _txtMessage.text,
                      );
                    });
                    _sendMessage(firestore);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final message = Message.fromSnapshot(snapshot);

    return MessageWidget(
      text: message.text,
      date: message.date,
      email: message.email,
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return Container(
      alignment: AlignmentDirectional.bottomEnd,
      child: ListView(
        shrinkWrap: true,
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 16.0),
        children:
            snapshot!.map((data) => _buildListItem(context, data)).toList(),
      ),
    );
  }

  Conversation _getConversation() {
    final roomId = roomID(widget.email, _auth.currentEmail()!);

    return Conversation(
      roomId: roomId,
      sender: _auth.currentName()!,
      senderEmail: _auth.currentEmail()!,
      receiverEmail: widget.email,
      receiver: widget.name,
      date: DateTime.now(),
      lastMessage: _txtMessage.text,
    );
  }

  Widget _getMessageList(FireStoreService firestore) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.getMessageStream(_getConversation()),
          builder: (context, snapshot) {
            WidgetsBinding.instance!
                .addPostFrameCallback((_) => _scrollToBottom());
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return _buildList(context, snapshot.data!.docs);
            }
          },
        ),
      ),
    );
  }

  void _sendMessage(FireStoreService firestore) {
    String? _currentEmail = _auth.currentEmail();

    if (_canSend()) {
      final _message = Message(
          text: _txtMessage.text, date: DateTime.now(), email: _currentEmail);

      firestore.saveMessage(_message, _getConversation());
      firestore.addUSerToChatRoom(_getConversation());
      // firestore.getLastMessage(_getConversation());

      _txtMessage.clear();
    }
  }

  // _sendSticker() {}

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent + 1);
    }
  }

  List roomID(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return [a, b];
    }
    return [b, a];
  }
}
