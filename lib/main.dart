import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restro_app/screens/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(mybackgroundmsghndler);
  runApp(MyApp());
  configLoading();
}

Future<void> mybackgroundmsghndler(RemoteMessage message) async {
  await Firebase.initializeApp();
  return _showNotif(message);
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future _showNotif(RemoteMessage msg) async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', 'high importance notification',
      //'this chanel used for importence notif',
      enableLights: true,
      importance: Importance.high);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  RemoteNotification? data = msg.notification;
  AndroidNotification? android = msg.notification?.android;
  if (data != null) {
    flutterLocalNotificationsPlugin.show(
        2,
        data.title,
        data.body,
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                icon: android?.smallIcon, setAsGroupSummary: true)));
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String fcmtoken = " lol";

  @override
  void initState() {
    getToken();
    var initializSettingAndroid =
        const AndroidInitializationSettings('logo');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializSettingAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    FirebaseMessaging.onMessage.listen((event) {
      _showNotif(event);
    });
    super.initState();
  }

  getToken() async {
    String? token = await _firebaseMessaging.getToken();
    setState(() {
      fcmtoken = token!;
    });

    print(fcmtoken);
  }

  onSelectNotification(payload) async {
    print("onselect: " + payload);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FetchLoc(),
      builder: EasyLoading.init(),
    );
  }
}
