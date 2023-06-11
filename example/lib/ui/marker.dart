import 'package:flutter/material.dart';

class Marker extends StatelessWidget {
  const Marker({super.key, required this.size});

  final double size;

  @override
  Widget build(Object context) {
    const black = Colors.black;
    const shape = BoxShape.circle;

    Widget curr = const Icon(Icons.remove_red_eye, size: 24, color: black);
    curr = FittedBox(child: curr);
    curr = Center(child: curr);
    curr = SizedBox(width: size / 2, height: size / 2, child: curr);

    curr = Center(child: curr);
    curr = Container(
      width: size / 1.4,
      height: size / 1.4,
      decoration: const BoxDecoration(shape: shape, color: Colors.white),
      child: curr,
    );

    curr = Center(child: curr);
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(shape: shape, color: Colors.green),
      child: curr,
    );
  }
}
