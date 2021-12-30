import 'package:canary_chat/base/base_event.dart';

class AddUserEvent extends BaseEvent {
  final String name;
  final String email;

  AddUserEvent({required this.name, required this.email});
}