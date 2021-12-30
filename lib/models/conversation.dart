import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final List? roomId;
  final String sender;
  final String senderEmail;
  final String receiverEmail;
  final String receiver;
  final String lastMessage;
  final DateTime date;

  DocumentReference? reference;

  Conversation(
      {this.roomId,
      required this.sender,
      required this.senderEmail,
      required this.receiverEmail,
      required this.receiver,
      required this.date,
      required this.lastMessage,
      this.reference});

  factory Conversation.fromJSon(Map<dynamic, dynamic> json) => Conversation(
        roomId: json['roomID'] as List,
        sender: json['sender'] as String,
        senderEmail: json['senderEmail'] as String,
        receiverEmail: json['receiverEmail'] as String,
        receiver: json['receiver'] as String,
        lastMessage: json['lastMessage'] as String,
        date: DateTime.parse(json['date'] as String),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'roomID': roomId,
        'sender': sender,
        'senderEmail': senderEmail,
        'receiverEmail': receiverEmail,
        'receiver': receiver,
        'lastMessage': lastMessage,
        'date': date.toString(),
      };

  factory Conversation.fromSnapshot(DocumentSnapshot snapshot) {
    final _conversation =
        Conversation.fromJSon(snapshot.data() as Map<String, dynamic>);
    _conversation.reference = snapshot.reference;
    return _conversation;
  }
}
