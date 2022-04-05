import 'package:time_puncher/calc/coords_calculations.dart';

class Coord {
  final double latitude;
  final double longitude;
  Coord(this.latitude, this.longitude);

  double distanceTo(Coord coord) {
    return CoordsCalculations.calculateDistance(
      lat1: latitude,
      lon1: longitude,
      lat2: coord.latitude,
      lon2: coord.longitude,
    );
  }
}
