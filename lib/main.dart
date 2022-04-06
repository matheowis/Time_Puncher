import 'package:flutter/material.dart';
import 'package:time_puncher/pages/main_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './globals.dart' as globals;

void main() async {
  // it has to be here if i want to initilize notifications
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
//initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          onDidReceiveLocalNotification: (i, a, b, c) =>
              print('initializationSettingsIOS - $i \n $a \n $b \n $c'));
  final MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  globals.flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (s) => print('flutterLocalNotificationsPlugin:$s'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}
