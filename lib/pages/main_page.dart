import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:time_puncher/buttons/app_button.dart';
import 'package:time_puncher/classes/coord.dart';
import 'package:time_puncher/dialogs/pop_map_dialog.dart';
import '../globals.dart' as globals;

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Location location = Location();
  Coord target = Coord(0, 0);
  Coord current = Coord(0, 0);
  double closest = double.infinity;
  String time = 'none';
  int listenCounter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    location.enableBackgroundMode();

    var listener = location.onLocationChanged.listen((currentLoc) {
      var latitude = currentLoc.latitude ?? 0;
      var longitude = currentLoc.longitude ?? 0;

      double distance = target.distanceTo(current);
      print('new location');
      if (listenCounter == 5) {
        print('do it');
        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails('your channel id', 'your channel name',
                channelDescription: 'your channel description',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker');
        const NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        globals.flutterLocalNotificationsPlugin.show(
            0, 'plain title', 'plain body', platformChannelSpecifics,
            payload: 'item x');
      }
      setState(() {
        current = Coord(latitude, longitude);
        time = DateTime.now().toIso8601String();
        listenCounter++;
        //if (distance < closest) {
        closest = distance;
        //}
      });
    });
  }

  void handleClick() async {
    print('popDialog');
    popMapDialog(context);
    return;
    var currentLoc = await location.getLocation();
    print(
        'latitude = ${currentLoc.latitude}, longitude = ${currentLoc.longitude}');
    var latitude = currentLoc.latitude ?? 0;
    var longitude = currentLoc.longitude ?? 0;
    setState(() {
      target = Coord(latitude, longitude);
      // closest
    });
  }

  void handleResetDistance() {
    setState(() => closest = double.infinity);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppButton(onPressed: handleClick, title: 'Save Target'),
            Container(
              width: width * 0.6,
              height: width * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width * 0.6),
                color: Colors.lightGreen[500],
              ),
              child: Center(
                  child: Text(
                'DISTANCE\n${closest.toStringAsFixed(2)}m',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[50],
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              )),
            ),
            AppButton(onPressed: handleResetDistance, title: 'reset distance'),
            Container(
              width: width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(width / 10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    [
                      'latitude = ${current.latitude}',
                      'longitude = ${current.longitude}',
                      'updated = ${time}',
                      'listerCount = $listenCounter'
                      // 'distance = ${target.distanceTo(current).toStringAsFixed(2)}m'
                    ].join('\n'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
