import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConversationWidget extends StatelessWidget {
  final String receiver;
  final String? text;
  final DateTime dateTime;

  const ConversationWidget({
    Key? key,
    required this.receiver,
    required this.text,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.pink,
              child: Text(receiver[0].toUpperCase()),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receiver,
                  style: const TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 32,
                  child: Text(
                    text!,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            trailing: Text(
              DateFormat('dd/MM/yyyy\nHH:mm:ss').format(dateTime).toString(),
              style: const TextStyle(
                  color: Colors.grey, fontStyle: FontStyle.italic),
              textAlign: TextAlign.end,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
