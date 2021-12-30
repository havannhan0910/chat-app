import 'package:canary_chat/base/base_event.dart';

class ValidateEvent extends BaseEvent {

  String? user;
  String? pass;
  String? confirmPass;

  ValidateEvent({this.user, this.pass, this.confirmPass});

  bool isValidUser () {
    return user != null && user!.contains("@");
  }

  bool isValidPass () {
    return pass != null && pass!.length >= 6;
  }

  bool confirmedPass () {
    return pass == confirmPass;
  }
}

