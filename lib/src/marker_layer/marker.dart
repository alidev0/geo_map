import 'package:flutter/material.dart';

import '../constants/constants.dart';

class Marker extends StatelessWidget {
  const Marker({super.key, required this.onTap, this.builder});

  final void Function() onTap;
  final Widget Function(double)? builder;

  @override
  Widget build(BuildContext context) {
    final lBuilder = builder;

    Widget current = lBuilder == null
        ? const _DefaultBuilder(size: clusterRadius * 2)
        : lBuilder(clusterRadius * 2);

    current = Center(child: current);

    current = SizedBox(
      width: clusterRadius * 2,
      height: clusterRadius * 2,
      child: current,
    );

    return GestureDetector(onTap: onTap, child: current);
  }
}

class _DefaultBuilder extends StatelessWidget {
  const _DefaultBuilder({required this.size});

  final double size;

  @override
  Widget build(Object context) {
    const green = Colors.green;
    const shape = BoxShape.circle;

    Widget curr = const Icon(Icons.remove_red_eye, size: 24, color: green);
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
