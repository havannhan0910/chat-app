import 'package:canary_chat/bloc/validate_bloc.dart';
import 'package:canary_chat/dialogs/failed_dialog.dart';
import 'package:canary_chat/dialogs/loading_dialog.dart';
import 'package:canary_chat/event/validate_event.dart';
import 'package:canary_chat/screens/home_page.dart';
import 'package:canary_chat/screens/signup_screen.dart';
import 'package:canary_chat/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _txtUser = TextEditingController();
  final _txtPass = TextEditingController();

  bool _showPass = false;
  final _bloc = ValidateBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Đăng nhập",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              StreamBuilder(
                  stream: _bloc.userStream,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _txtUser,
                      decoration: InputDecoration(
                        errorText: snapshot.hasError
                            ? snapshot.error.toString()
                            : null,
                        labelText: "Email",
                        hintText: "example@example.com",
                        border: const OutlineInputBorder(),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    );
                  }),
              const SizedBox(
                height: 16,
              ),
              Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  StreamBuilder(
                    stream: _bloc.passStream,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _txtPass,
                        obscureText: !_showPass,
                        decoration: InputDecoration(
                          errorText: snapshot.hasError
                              ? snapshot.error.toString()
                              : null,
                          labelText: "Mật khẩu",
                          hintText: "Nhập mật khẩu",
                          border: const OutlineInputBorder(),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Icon(
                        _showPass ? Icons.visibility : Icons.visibility_off,
                        color: Colors.blueAccent,
                      ),
                      onTap: () {
                        setState(() {
                          _showPass = !_showPass;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  child: const Text("Đăng nhập"),
                  onPressed: _onToggleSignIn,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Quên mật khẩu ?",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Chưa có tài khoản ? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SignUpScreen()));
                        },
                        child: const Text(
                          "Đăng ký",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onToggleSignIn() async {
    final _auth = AuthService();
    const String _title = "Đang đăng nhập...";

    final _validate = ValidateEvent(
        user: _txtUser.text, pass: _txtPass.text, confirmPass: _txtPass.text);

    if (_bloc.isValidInfo(_validate)) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => LoadingDialog(text: _title));

      _auth.userState.listen((User? user) {
        if (user != null) {
          Navigator.of(context).pop(LoadingDialog(text: _title));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
        }
      });

      await _auth.signIn(_txtUser.text, _txtPass.text, (error) {
        Navigator.of(context).pop(LoadingDialog(text: _title));

        showDialog(
            context: context, builder: (_) => FailedDialog(error: error));
      });
    }
  }
}
