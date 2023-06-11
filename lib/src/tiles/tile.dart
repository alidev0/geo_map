import 'dart:io';

import 'package:flutter/material.dart';

import '../calculations/calculator.dart';
import '../debug/map_log.dart';
import '../models/pixel_point.dart';
import '../models/tile_point.dart';
import '../providers/cache_prov.dart';
import '../providers/tile_prov.dart';

/// PositionedTile
class PositionedTile extends StatelessWidget {
  const PositionedTile({
    required this.mapScale,
    required this.zoom,
    required this.center,
    required this.tile,
    super.key,
  });

  final double mapScale;
  final double zoom;
  final PixelPoint center;
  final TilePoint tile;

  @override
  Widget build(BuildContext context) {
    final fullSize = MediaQuery.of(context).size;
    final fullW = fullSize.width;
    final fullH = fullSize.height;

    final scaledSize = getUnitSize(zoom: tile.z.toDouble(), mapScale: mapScale);

    final pixelX = tile.x * scaledSize.abs();
    final pixelY = tile.y * scaledSize.abs();
    final size = scaledSize;

    return Positioned(
      left: pixelX + (fullW / 2) - center.x,
      top: pixelY + (fullH / 2) - center.y,
      child: TileWidget(
        key: ValueKey(tile.key),
        tile: tile,
        zoom: zoom,
        size: size,
      ),
    );
  }
}

/// TileWidget
class TileWidget extends StatelessWidget {
  const TileWidget({
    super.key,
    required this.tile,
    required this.zoom,
    required this.size,
  });

  final TilePoint tile;
  final double zoom;
  final double size;

  @override
  Widget build(BuildContext context) {
    Widget current = const SizedBox();

    if (zoom < tile.z.toDouble()) return current;

    final isDown = cacheProvider.isDown(tile);
    if (!isDown) return current;

    final filePath = tileProvider.path(tile);

    current = Image.file(File(filePath), fit: BoxFit.fill);
    current = SizedBox(width: size, height: size, child: current);

    if (MapLog.debugMode) {
      current = WarpIt(tile: tile, size: size, child: current);
    }

    return current;
  }
}

/// WarpIt
class WarpIt extends StatelessWidget {
  const WarpIt({
    super.key,
    required this.tile,
    required this.size,
    required this.child,
  });

  final TilePoint tile;
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    Widget current = Container(
      decoration: BoxDecoration(border: Border.all()),
      child: child,
    );

    current = Stack(
      alignment: Alignment.center,
      children: [current, Text('${tile.x}, ${tile.y}, ${tile.z}')],
    );

    return SizedBox(width: size, height: size, child: current);
  }
}
