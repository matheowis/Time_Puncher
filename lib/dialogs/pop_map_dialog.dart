import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

Future<LatLng> popMapDialog(BuildContext context) {
  var completer = Completer<LatLng>();
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
          child: Container(
            height: width - 48,
            // color: Colors.red,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: width - 48,
                  // color: Colors.black,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: mapBorderRadius,
                        child: FlutterMap(
                          // mapController: ,
                          options: MapOptions(
                              center: LatLng(
                                49.6694132,
                                20.6869835,
                              ),
                              zoom: 18.0,
                              maxZoom: 20,
                              onPositionChanged: (pos, check) {
                                print(
                                    'lat = ${pos.center?.latitude}, lon = ${pos.center?.longitude}');
                              }),
                          layers: [
                            TileLayerOptions(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: ['a', 'b', 'c'],
                              // For example purposes. It is recommended to use
                              // TileProvider with a caching and retry strategy, like
                              // NetworkTileProvider or CachedNetworkTileProvider
                              tileProvider: NonCachingNetworkTileProvider(),
                            ),
                          ],
                        ),
                      ),
                      IgnorePointer(
                        child: Align(
                          alignment: AlignmentDirectional.center,
                          child: Icon(
                            Icons.place_rounded,
                            color: Colors.blue,

                            // size,
                            // size: width,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('SAVE'),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });

  return completer.future;
}
