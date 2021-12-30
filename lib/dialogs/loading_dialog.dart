import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {

  String text;
  LoadingDialog({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Center(
          child: Column(
            children: <Widget>[
              Text(text),
              const SizedBox(height: 12,),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ],
    );
  }
}
