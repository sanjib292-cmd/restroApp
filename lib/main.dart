import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:restro_app/screens/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(mybackgroundmsghndler);
  runApp(MyApp());
  configLoading();
}

Future<void> mybackgroundmsghndler(RemoteMessage message) async {
  final player = AudioPlayer();

  await Firebase.initializeApp();
  await player.setAsset('images/orderAlert.mp3');
  player.play();
  FlutterRingtonePlayer.play(
    android: AndroidSounds.notification,
    ios: IosSounds.glass,
    looping: false, // Android only - API >= 28
    volume: 1, // Android only - API >= 28
    asAlarm: true, // Android only - all APIs
  );
  return _showNotif(message);
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future _showNotif(RemoteMessage msg) async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      //'this chanel used for importence notif',
      sound: RawResourceAndroidNotificationSound('alert'),
      enableLights: true,
      playSound: true,
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
                importance: Importance.high,
                priority: Priority.high,
                additionalFlags: Int32List.fromList(<int>[4]),
                icon: android?.sound,
                setAsGroupSummary: true)));
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
    FlutterRingtonePlayer.stop();
    getToken();
    var initializSettingAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializSettingAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      RemoteNotification? _notification = event.notification;
      AndroidNotification? android = event.notification?.android;
      if (_notification != null && android != null) {
        _showNotif(event);
      }
      // _showNotif(event);
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
