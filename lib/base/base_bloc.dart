import 'dart:async';

import 'package:canary_chat/base/base_event.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseBloc {
  final StreamController<BaseEvent> _eventController = StreamController<BaseEvent>();

  Sink<BaseEvent> get event => _eventController.sink;

  BaseBloc() {
    _eventController.stream.listen((event) {
      if (event is! BaseEvent) throw Exception("Invalid Event");
      dispatchEvent(event);
    });
  }

  dispatchEvent(BaseEvent event);

  @mustCallSuper
  void dispose() {
    _eventController.close();
  }
}
