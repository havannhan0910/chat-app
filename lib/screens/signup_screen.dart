import 'package:canary_chat/bloc/validate_bloc.dart';
import 'package:canary_chat/dialogs/failed_dialog.dart';
import 'package:canary_chat/dialogs/loading_dialog.dart';
import 'package:canary_chat/dialogs/success_dialog.dart';
import 'package:canary_chat/event/validate_event.dart';
import 'package:canary_chat/screens/home_page.dart';
import 'package:canary_chat/screens/login_screen.dart';
import 'package:canary_chat/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _txtName = TextEditingController();
  final _txtUser = TextEditingController();
  final _txtPass = TextEditingController();
  final _txtConfirm = TextEditingController();

  final _bloc = ValidateBloc();
  bool _showPass = false;
  bool _showConfirm = false;

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
            children: <Widget>[
              const Center(
                child: Text(
                  "Đăng ký tài khoản",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              //Create Name
              TextFormField(
                controller: _txtName,
                decoration: const InputDecoration(
                  labelText: "Tên người dùng",
                  hintText: "Nhập tên",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              //Create user email
              StreamBuilder(
                  stream: _bloc.userStream,
                  builder: (context, snapshot) {
                    return TextFormField(
                      controller: _txtUser,
                      keyboardType: TextInputType.emailAddress,
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
              const SizedBox(height: 16),
              //Create Password
              Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
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
                      }),
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
                height: 16,
              ),
              //Confirm Password
              Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  StreamBuilder(
                      stream: _bloc.confirmStream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          controller: _txtConfirm,
                          obscureText: !_showConfirm,
                          decoration: InputDecoration(
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                            labelText: "Nhập lại mật khẩu",
                            border: const OutlineInputBorder(),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Icon(
                        _showConfirm ? Icons.visibility : Icons.visibility_off,
                        color: Colors.blueAccent,
                      ),
                      onTap: () {
                        setState(() {
                          _showConfirm = !_showConfirm;
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
                  child: const Text("Đăng ký"),
                  onPressed: _onToggleSignUp,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Đã có tài khoản ?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LogInScreen()));
                      },
                      child: const Text(
                        "Đăng nhập",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onToggleSignUp() async {
    final _auth = AuthService();
    const String _title = "Đang đăng ký ...";

    final _validate = ValidateEvent(user: _txtUser.text, pass: _txtPass.text, confirmPass: _txtConfirm.text);

    if (_bloc.isValidInfo(_validate)) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => LoadingDialog(text: _title));

      _auth.userState.listen((User? user) {
        if (user != null) {
          Navigator.of(context).pop(LoadingDialog(text: _title));
          showDialog(context: context, builder: (_) => const SuccessDialog());
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
        }
      });

      await _auth.signUp(
        name: _txtName.text,
        email: _txtUser.text,
        password: _txtPass.text,
        onError: (error) {
          Navigator.of(context).pop(LoadingDialog(text: _title));

          showDialog(
              context: context, builder: (_) => FailedDialog(error: error));
        },
      );
    }
  }
}
