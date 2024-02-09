import 'package:flutter/material.dart';

import '../models/marker.dart';
import '../models/pixel_point.dart';
import '../ui/helper.dart';
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
    final fullSize = Helper.sizeOf(context);
    final fullW = fullSize.width;
    final fullH = fullSize.height;

    final markerRad = Helper.markerRadOf(context);

    return Positioned(
      left: point.x + (fullW / 2) - mapCenter.x - markerRad,
      top: point.y + (fullH / 2) - mapCenter.y - markerRad,
      child: MarkerUI(builder: builder, onTap: onTap, marker: marker),
    );
  }
}
