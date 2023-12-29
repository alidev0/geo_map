import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/marker.dart';
import '../models/pixel_point.dart';
import 'marker.dart';

/// PositionedMarker
class PositionedMarker extends StatelessWidget {
  const PositionedMarker({
    required this.marker,
    required this.point,
    required this.mapCenter,
    required this.onTap,
    this.builder,
    super.key,
  });

  final Marker marker;
  final PixelPoint point;
  final PixelPoint mapCenter;
  final void Function() onTap;
  final Widget Function(double, Map<String, dynamic>?)? builder;

  @override
  Widget build(BuildContext context) {
    final fullSize = MediaQuery.of(context).size;
    final fullW = fullSize.width;
    final fullH = fullSize.height;

    return Positioned(
      left: point.x + (fullW / 2) - mapCenter.x - clusterRadius,
      top: point.y + (fullH / 2) - mapCenter.y - clusterRadius,
      child: MarkerUI(builder: builder, onTap: onTap, marker: marker),
    );
  }
}
