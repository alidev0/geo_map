import 'package:flutter/material.dart';

import 'style.dart';

class Cluster extends StatelessWidget {
  const Cluster({super.key, required this.count, required this.size});

  final int count;
  final double size;

  @override
  Widget build(Object context) {
    const shape = BoxShape.circle;

    Widget current = Text('$count', style: textStyle);
    current = Center(child: current);

    current = Container(
      width: size / 1.4,
      height: size / 1.4,
      decoration: const BoxDecoration(shape: shape, color: Colors.white),
      child: current,
    );

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(shape: shape, color: Colors.green),
      child: current,
    );
  }
}
