import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:hiinternet/data/notification_model.dart';
import 'package:hiinternet/utils/app_constants.dart';

class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channel_id = "hiinternetnoti";

  Future<void> init() async {

    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher.png');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid, iOS: null, macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    tz.initializeTimeZones();
  }

  Future selectNotification(String payload) async {
    NotiModel notiModel = getNotiModelFromPayload(payload);
    cancelNotification(notiModel);

  }

  void showNotification(NotiModel notiModel) async {
    await flutterLocalNotificationsPlugin.show(
        notiModel.hashCode,
        notiModel.title,
        notiModel.body,
        const NotificationDetails(
            android: AndroidNotificationDetails(channel_id, appName, 'HiInternet Noti')
        ),
        payload: jsonEncode(notiModel)
    );
  }
/*
  void scheduleNotification(NotiModel notiModel, String notificationMessage) async {
    DateTime now = DateTime.now();
    DateTime birthdayDate = notiModel.birthdayDate;
    Duration difference = now.isAfter(birthdayDate)
        ? now.difference(birthdayDate)
        : birthdayDate.difference(now);

    _wasApplicationLaunchedFromNotification().then((bool didApplicationLaunchFromNotification) => {
      showNotification(notiModel, notificationMessage);
    });

    await flutterLocalNotificationsPlugin.zonedSchedule(
        notiModel.hashCode,
        appName,
        notificationMessage,
        tz.TZDateTime.now(tz.local).add(difference),
        const NotificationDetails(
            android: AndroidNotificationDetails(channel_id, appName,
                'To remind you about upcoming birthdays')),
        payload: jsonEncode(notiModel),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }
*/
  void cancelNotification(NotiModel birthday) async {
    await flutterLocalNotificationsPlugin.cancel(birthday.hashCode);
  }

  void cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void handleApplicationWasLaunchedFromNotification() async {
    final NotificationAppLaunchDetails notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails.didNotificationLaunchApp) {
      NotiModel notiModel = getNotiModelFromPayload(notificationAppLaunchDetails.payload);
      cancelNotification(notiModel);

    }
  }

  NotiModel getNotiModelFromPayload(String payload) {
    Map<String, dynamic> json = jsonDecode(payload);
    NotiModel notiModel = NotiModel.fromJson(json);

    return notiModel;
  }

  Future<bool> _wasApplicationLaunchedFromNotification() async {
    final NotificationAppLaunchDetails notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    return notificationAppLaunchDetails.didNotificationLaunchApp;
  }
}
