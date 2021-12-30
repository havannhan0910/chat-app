import 'dart:async';
import 'package:canary_chat/event/validate_event.dart';

class ValidateBloc {
  final _userController = StreamController();
  final _passController = StreamController();
  final _confirmController = StreamController();

  Stream get userStream => _userController.stream;

  Stream get passStream => _passController.stream;

  Stream get confirmStream => _confirmController.stream;

  bool isValidInfo(ValidateEvent _validate) {
    if (!_validate.isValidUser()) {
      _userController.sink.addError("Tài khoản không hợp lệ");
      return false;
    }
    if (!_validate.isValidPass()) {
      _passController.sink.addError("Mật khẩu phải trên 6 ký tự");
      return false;
    }
    if (!_validate.confirmedPass()) {
      _confirmController.sink.addError("Mật khẩu không giống nhau");
      return false;
    }
    return true;
  }

  void dispose() {
    // TODO: implement dispose
    _userController.close();
    _passController.close();
    _confirmController.close();
  }
}
