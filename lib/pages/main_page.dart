import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:time_puncher/buttons/app_button.dart';
import 'package:time_puncher/classes/coord.dart';
import 'package:time_puncher/dialogs/pop_map_dialog.dart';
import 'package:time_puncher/notification_utils.dart';
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
  bool canNotify = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    location.enableBackgroundMode();

    var listener = location.onLocationChanged.listen((currentLoc) {
      var latitude = currentLoc.latitude;
      var longitude = currentLoc.longitude;
      if (latitude == null || longitude == null) return;
      double distance = target.distanceTo(current);
      if (distance < 2 && canNotify) {
        NotificationUtils.notify(title: 'You are near the card reader');
        setState(() => canNotify = false);
        Timer(
          const Duration(minutes: 3),
          () => setState(() => canNotify = true),
        );
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
    Coord coord;
    if (target != null) {
      coord = await popMapDialog(context, target);
    } else {
      var currentLoc = await location.getLocation();
      var latitude = currentLoc.latitude;
      var longitude = currentLoc.longitude;
      if (latitude == null || longitude == null) return;
      coord = await popMapDialog(context, Coord(latitude, longitude));
    }
    setState(() {
      target = coord;
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
            // AppButton(onPressed: handleResetDistance, title: 'reset distance'),
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
                      'latitude = ${target.latitude}',
                      'longitude = ${target.longitude}',
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
