import 'package:flutter/material.dart';

class MarkerWi extends StatelessWidget {
  const MarkerWi({super.key, required this.size, required this.data});

  final double size;
  final Map<String, dynamic>? data;

  @override
  Widget build(Object context) {
    const black = Colors.black;
    const shape = BoxShape.circle;

    Widget current = const Icon(Icons.remove_red_eye, size: 24, color: black);
    current = FittedBox(child: current);
    current = Center(child: current);
    current = SizedBox(width: size * 0.5, height: size * 0.5, child: current);

    current = Center(child: current);
    current = SizedBox(width: size * 0.7, height: size * 0.7, child: current);
    current = Container(
      decoration: const BoxDecoration(shape: shape, color: Colors.white),
      child: current,
    );

    current = Center(child: current);
    current = SizedBox(width: size, height: size, child: current);
    return Container(
      decoration: const BoxDecoration(shape: shape, color: Colors.green),
      child: current,
    );
  }
}
