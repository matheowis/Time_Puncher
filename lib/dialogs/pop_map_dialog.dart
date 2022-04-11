import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:time_puncher/classes/coord.dart';
import 'package:time_puncher/widgets/map_view.dart';

Future<Coord> popMapDialog(BuildContext context, Coord coord) {
  var completer = Completer<Coord>();
  var width = MediaQuery.of(context).size.width;

  var mapBorderRadius = BorderRadius.circular(width / 16);

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: mapBorderRadius),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 24,
        ),
        child: MapView(
          onSave: (p) {
            completer.complete(Coord(p.latitude, p.longitude));
            Navigator.pop(context);
          },
          borderRadius: mapBorderRadius,
          coord: coord,
        ),
      );
    },
  );

  return completer.future;
}
