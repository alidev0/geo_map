import 'package:flutter/material.dart';
import '../models/pixel_point.dart';

/// MyLocation
class MyLocation extends StatelessWidget {
  const MyLocation({super.key, required this.pixelPoint, required this.center});
  final PixelPoint pixelPoint;
  final PixelPoint center;

  @override
  Widget build(BuildContext context) {
    final fullSize = MediaQuery.of(context).size;
    final fullW = fullSize.width;
    final fullH = fullSize.height;

    const size = 48.0;
    final blue = Colors.blue[900];
    const shape = BoxShape.circle;

    Widget current = Container(
      width: size / 4,
      height: size / 4,
      decoration: BoxDecoration(shape: shape, color: blue),
    );

    current = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: shape, color: blue!.withOpacity(0.3)),
      child: current,
    );

    return Positioned(
      left: pixelPoint.x + (fullW / 2) - center.x - (size / 2),
      top: pixelPoint.y + (fullH / 2) - center.y - (size / 2),
      child: current,
    );
  }
}
