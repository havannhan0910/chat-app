import 'package:flutter/material.dart';

class FailedDialog extends StatelessWidget {
  String error;
  FailedDialog({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Center(
          child: Text(error),
        ),
        const SizedBox(height: 12,),
        const Icon(Icons.warning_amber, color: Colors.red, size: 60,),
      ],
    );
  }
}
