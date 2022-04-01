import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsAPI {
  static final flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    AndroidInitializationSettings settingAndroid =
        const AndroidInitializationSettings('app_icon');

    IOSInitializationSettings settingIOS = const IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: settingAndroid,
      iOS: settingIOS,
      macOS: null,
    );

    await flutterLocalNotificationPlugin.initialize(
      initializationSettings,
      // onSelectNotification: selectNotification,
    );
  }

  static Future<void> display({String? title, String? body}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.max,
    );

    IOSNotificationDetails iOSPlatformChannelSpecifics =
        const IOSNotificationDetails();

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
