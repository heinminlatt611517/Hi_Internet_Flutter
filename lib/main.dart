import 'package:flutter/material.dart';
import 'package:hiinternet/providers/service_history_ticket.dart';
import 'package:hiinternet/screens/tabs_screen/tab_screen.dart';

import 'package:splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hiinternet/service/notification_service.dart';
import 'package:hiinternet/utils/firebase_token_sender.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:hiinternet/data/notification_model.dart';
import 'package:hiinternet/data/database_util.dart';

import 'package:hiinternet/utils/eventbus_util.dart';
import 'dart:io';

import 'dart:convert';

Future<void> _onReceivedBackgroundFirebaseMsg(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Firebase background msg received");

  //onReceivedFirebaseMsg(message);

  NotiModel notiModel = NotiModel.fromJson(message.data);

  if (notiModel != null) {
    EventBusUtils.getInstance().fire(notiModel);
    DatabaseUtil().InitDatabase().then((value) {
      DatabaseUtil().insertNotification(notiModel);
    });

  }
}

void onReceivedFirebaseMsg(RemoteMessage message) {
  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
    print('notification.body' + message.notification.body + ', notification.body' + message.notification.title);
  }

  if (message.data != null) {
    print('Message also contained a data: ' + jsonEncode(message.data));
  }

  NotiModel notiModel = NotiModel.fromJson(message.data);

  if (notiModel != null) {
    EventBusUtils.getInstance().fire(notiModel);

    DatabaseUtil().insertNotification(notiModel);
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  DatabaseUtil().InitDatabase();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: ServiceHistoryTicket()),
    ],
    child: new MaterialApp(
      theme: ThemeData(
          primaryColor: Color(0xff004785),
          primarySwatch: Colors.blue,
          primaryColorDark: Color(0xFF181F3C),
          accentColor: Colors.amber,
          textTheme: ThemeData.light().textTheme.copyWith(
                button: TextStyle(color: Colors.white),
              )),
        debugShowCheckedModeBanner: false,
      home: MyApp(),
      routes: {/*
        HomeScreen.routeName: (ctx) => HomeScreen("ENG"),
        PaymentScreen.routeName: (ctx) => PaymentScreen(),
        NotificationScreen.routeName: (ctx) => NotificationScreen(),
        AccountScreen.routeName: (ctx) => AccountScreen(),
        ServiceHistoryScreen.routeName: (ctx) => ServiceHistoryScreen(),
        ServiceIssueScreen.routeName: (ctx) => ServiceIssueScreen(),*/
        TabScreen.routeName: (ctx) => TabScreen(),
      },
    ),
  ));
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _initialized = false;
  bool _setupNotificationSystems = false;
  bool _error = false;

  FirebaseMessaging _messaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AndroidNotificationChannel channel;

  final _firebaseTokenSenderBloc = FirebaseTokenSenderBloc();

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();

      channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.max,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  void initializeFirebaseMsg() async {
    if(_setupNotificationSystems) return;
    _setupNotificationSystems = true;

    _messaging = FirebaseMessaging.instance;

    await FirebaseMessaging.instance.subscribeToTopic('hi');

    // send firebase token to the server
    _messaging.getToken().then((token) {
      print(token);
      sendFirebaseToken(token);
    });



    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onReceivedFirebaseMsg(message);
      NotiModel notiModel = NotiModel.fromJson(message.data);

      if (notiModel != null) {
        flutterLocalNotificationsPlugin.show(
            notiModel.hashCode,
            notiModel.title,
            notiModel.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: '@mipmap/ic_launcher',
              ),
            )
        );
      }

    });

    FirebaseMessaging.onBackgroundMessage(_onReceivedBackgroundFirebaseMsg);

  }

  @override
  void initState() {
    initializeFlutterFire();
    NotificationService().handleApplicationWasLaunchedFromNotification();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_initialized) {
      initializeFirebaseMsg();
    }

    return Center(
      child: SplashScreen(
        seconds: 3,
        navigateAfterSeconds: new AfterSplash(),
        title: Text(
          'Loading...',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: Image.asset(
          'assets/images/floating_icon.png',
        ),
        photoSize: 50,
        backgroundColor: Theme.of(context).primaryColorDark,
        loaderColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    //EventBusUtils.getInstance().destroy();
    super.dispose();
  }

  void sendFirebaseToken(String token) {
    SharedPref.getData(key: SharedPref.user_id).then((value) {
      if (value != null && value.toString() != 'null') {
        String userId = json.decode(value).toString();
        Map<String, String> map = {
          'user_id': userId,
          'app_version': app_version,
          'firebase_token': token
        };

        _firebaseTokenSenderBloc.sendFirebaseTokenToServer(map);
      }
    });

  }
//finish
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabScreen();
  }
}
