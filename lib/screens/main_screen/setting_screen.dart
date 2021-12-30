import 'package:canary_chat/dialogs/loading_dialog.dart';
import 'package:canary_chat/screens/login_screen.dart';
import 'package:canary_chat/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();

    const String _title = "Đang đăng xuất...";

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _auth.currentName().toString(),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(_auth.currentEmail()!, style: const TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                  ),)
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    child: const Text("Đăng xuất"),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (_) => LoadingDialog(text: _title));

                      _auth.userState.listen((User? user) {
                        if (user == null) {
                          Navigator.of(context)
                              .pop(LoadingDialog(text: _title));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LogInScreen()));
                        }
                      });
                      await _auth.signOut();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
