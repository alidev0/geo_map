import 'package:flutter/widgets.dart';

import 'lat_lon.dart';

/// Polyline object
class Polyline {
  Polyline({
    required this.points,
    required this.color,
    this.width = 1,
    this.close = false,
  });

  final List<LatLon> points;
  final Color color;
  final double width;
  final bool close;
}
