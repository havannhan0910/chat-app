import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SimpleDialog(
      children: [
        Center(
          child: Text("Đăng ký thành công"),
        ),
        SizedBox(height: 12,),
        Icon(Icons.check_circle, color: Colors.blue, size: 60,),
      ],
    );
  }
}
