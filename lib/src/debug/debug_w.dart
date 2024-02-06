import 'package:flutter/material.dart';

import '../calculations/calculator.dart';
import '../models/tile_point.dart';
import '../ui/helper.dart';
import '../ui/style.dart';

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
    final fullSize = Helper.sizeOf(context);
    final fullW = fullSize.width;

    final mapScale = Helper.mapScaleOf(context);
    final center = Helper.centerOf(context);

    final centerTile =
        getCenterTile(center: center, zoom: zoom, mapScale: mapScale);

    Widget item(String title, String value, bool isLeft) {
      final align = isLeft ? Alignment.centerLeft : Alignment.centerRight;
      Widget curr = Text('$title: $value', style: textStyle);
      curr = FittedBox(fit: BoxFit.scaleDown, child: curr);
      curr = Align(alignment: align, child: curr);
      return Expanded(child: curr);
    }

    Widget current = Column(
      children: [
        Row(
          children: [
            item('x', center.x.format(), true),
            item('Tiles', loadedTiles.length.toString(), false),
          ],
        ),
        Row(
          children: [
            item('y', center.y.format(), true),
            item('Zoom', zoom.format(), false),
          ],
        ),
        Row(
          children: [
            item('CT', centerTile.toString(), true),
            item('Scale', mapScale.format(), false),
          ],
        ),
      ],
    );

    current = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: current,
    );

    current = SizedBox(width: fullW, child: current);
    current = ColoredBox(color: Colors.white, child: current);
    current = Positioned(top: 0, left: 0, child: current);

    return current;
  }
}

extension SomeExtension on double {
  String format() {
    var val = toStringAsFixed(3);
    while (val.endsWith('0') || val.endsWith('.')) {
      val = val.replaceRange(val.length - 1, val.length, '');
    }
    return val;
  }
}
