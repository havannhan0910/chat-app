import 'package:canary_chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageWidget extends StatelessWidget {
  final String text;
  final String? email;
  final DateTime date;

  const MessageWidget(
      {Key? key, required this.text, this.email, required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _auth = AuthService();

    return email == _auth.currentEmail() ? currentUserMessage() : otherUSerMessage();
  }

  Widget currentUserMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[400]!,
                  blurRadius: 1.0,
                  offset: const Offset(0.0, 1.0),
                )
              ],
              borderRadius: BorderRadius.circular(50.0),
              color: const Color.fromRGBO(4, 180, 245, 0.8)
            ),
            child: Container(
              // disabledTextColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              // alignment: Alignment.topRight,
              // onPressed: null,
              child: Wrap(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(text),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                DateFormat('dd/MM, HH:mm:ss').format(date).toString(),
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget otherUSerMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[400]!,
                  blurRadius: 1.0,
                  offset: const Offset(0.0, 1.0),
                )
              ],
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.grey[300],
            ),
            child: Container(
              // disabledTextColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              // alignment: Alignment.topRight,
              // onPressed: null,
              child: Wrap(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(text),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                DateFormat('dd/MM, HH:mm:ss').format(date).toString(),
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
