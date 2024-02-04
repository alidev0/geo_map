import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/pixel_point.dart';
import '../ui/helper.dart';
import 'cluster.dart';

/// PositionedCluster
class PositionedCluster extends StatelessWidget {
  const PositionedCluster({
    required this.point,
    required this.mapCenter,
    required this.count,
    required this.onTap,
    this.builder,
    super.key,
  });

  final PixelPoint point;
  final PixelPoint mapCenter;
  final int count;
  final void Function() onTap;
  final Widget Function(int count, double size)? builder;

  @override
  Widget build(BuildContext context) {
    final fullSize = Helper.sizeOf(context);
    final fullW = fullSize.width;
    final fullH = fullSize.height;

    return Positioned(
      left: point.x + (fullW / 2) - mapCenter.x - clusterRadius,
      top: point.y + (fullH / 2) - mapCenter.y - clusterRadius,
      child: Cluster(count: count, onTap: onTap, builder: builder),
    );
  }
}
