import 'package:flutter/material.dart';

import '../calculations/calculator.dart';
import '../models/tile_point.dart';
import '../ui/helper.dart';

/// DebugW
class DebugW extends StatelessWidget {
  const DebugW({
    super.key,
    required this.sizeRef,
    required this.zoomRef,
    required this.zoom,
    required this.loadedTiles,
  });

  final double sizeRef;
  final double zoomRef;
  final double zoom;
  final List<TilePoint> loadedTiles;

  @override
  Widget build(BuildContext context) {
    final fullSize = MediaQuery.of(context).size;
    final fullW = fullSize.width;

    final mapScale = Helper.mapScaleOf(context);
    final center = Helper.centerOf(context);

    final centerTile =
        getCenterTile(center: center, zoom: zoom, mapScale: mapScale);

    final lZoom = (zoom * 1000000).toInt() / 1000000;
    final lMapScale = (mapScale * 1000).toInt() / 1000;

    Widget current = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('x: ${center.x}'),
            Text('Tiles: ${loadedTiles.length}'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('y: ${center.y}'),
            Text('Zoom: $lZoom'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Center Tile: $centerTile'),
            Text('MapScale: $lMapScale'),
          ],
        ),
      ],
    );

    current = SizedBox(width: fullW, child: current);
    current = ColoredBox(color: Colors.white, child: current);
    current = Positioned(top: 0, left: 0, child: current);

    return current;
  }
}
