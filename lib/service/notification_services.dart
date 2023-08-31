import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotifyService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    // _configureLocalTimezone();

    final DarwinInitializationSettings initializationSettingsIOS =
        //* 初期化時には許可を求めない（ダイアログ出さない）
        DarwinInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('fish');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
      macOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: selectNotification);
  }

  ///
  /// イニシャライズ　ここまで
  ///
  ///

  // アプリがフォアグラウンドにあるときに通知がトリガーされたときに処理するためのコールバック。

  // このプロパティは、10より古いバージョンのiOSにのみ適用されます。

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page

    Get.dialog(const Text('🐯　onDidReceiveLocalNotification'));
  }

  void selectNotification(NotificationResponse response) async {
    final payload = response.payload;
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    print('taped notification');
  }

  // ローカル通知呼び出し
  displayNotification({required String title, required String body}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        // app info に表示される　(channel name )
        'your channel id',
        'edo task local notification',
        channelDescription: 'チャンネルの説明',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'It could be anything you pass',
    );
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestPermission();
    }
  }
}
