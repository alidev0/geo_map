import 'package:flutter/widgets.dart';

import 'lat_lon.dart';

class Polyline {
  Polyline({
    required this.points,
    required this.color,
    this.width = 1,
  });

  final List<LatLon> points;
  final Color color;
  final double width;
}
