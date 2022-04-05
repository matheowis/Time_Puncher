import 'dart:math' as math;

class CoordsCalculations {
  CoordsCalculations._();

  static double calculateDistance({
    required double lat1,
    required double lat2,
    required double lon1,
    required double lon2,
  }) {
    double R = 6371e3; // metres
    double o1 = lat1 * math.pi / 180; // φ, λ in radians
    double o2 = lat2 * math.pi / 180;
    double do1 = (lat2 - lat1) * math.pi / 180;
    double dl1 = (lon2 - lon1) * math.pi / 180;

    double a = math.sin(do1 / 2) * math.sin(do1 / 2) +
        math.cos(o1) * math.cos(o2) * math.sin(dl1 / 2) * math.sin(dl1 / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double d = R * c; // in metres
    return d;
  }
}
