import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:time_puncher/classes/coord.dart';

class MapView extends StatefulWidget {
  final void Function(LatLng position) onSave;
  final BorderRadius borderRadius;
  final Coord coord;
  const MapView({
    Key? key,
    required this.onSave,
    required this.borderRadius,
    required this.coord,
  }) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng? position = null;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }

  void handlePositionChanged(MapPosition mapPosition, bool _) async {
    if (!mounted) return;
    if (SchedulerBinding.instance?.schedulerPhase != SchedulerPhase.idle) {
      await SchedulerBinding.instance?.endOfFrame;
      if (!mounted) return;
    }
    setState(() => position = mapPosition.center);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
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
                  borderRadius: widget.borderRadius,
                  child: FlutterMap(
                    // mapController: ,
                    options: MapOptions(
                      center: LatLng(
                        widget.coord.latitude,
                        widget.coord.longitude,
                      ),
                      zoom: 18.0,
                      maxZoom: 20,
                      onPositionChanged: handlePositionChanged,
                    ),
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
                const IgnorePointer(
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
                Center(
                  child: Column(
                    children: [
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if (position == null) return;
                          widget.onSave(position!);
                        },
                        child: Text('SAVE'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) =>
                                  position != null ? Colors.blue : Colors.grey),
                        ),
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
    );
  }
}
