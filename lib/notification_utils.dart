import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './globals.dart' as globals;

class NotificationUtils {
  NotificationUtils._();

  static void notify({required String title, String? body}) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    globals.flutterLocalNotificationsPlugin.show(
        0, title, body ?? '', platformChannelSpecifics,
        payload: 'item x');
  }
}
