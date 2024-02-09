import 'package:flutter/material.dart';

import '../ui/helper.dart';
import '../ui/style.dart';

/// Cluster
class Cluster extends StatelessWidget {
  const Cluster({
    super.key,
    required this.count,
    required this.onTap,
    this.builder,
  });

  final int count;
  final void Function() onTap;
  final Widget Function(int count, double size)? builder;

  @override
  Widget build(BuildContext context) {
    final markerRad = Helper.markerRadOf(context);

    final lBuilder = builder;

    Widget current = lBuilder == null
        ? _DefaultBuilder(count: count, size: markerRad * 2)
        : lBuilder(count, markerRad * 2);

    current = Center(child: current);

    current = SizedBox(
      width: markerRad * 2,
      height: markerRad * 2,
      child: current,
    );

    return GestureDetector(onTap: onTap, child: current);
  }
}

/// _DefaultBuilder
class _DefaultBuilder extends StatelessWidget {
  const _DefaultBuilder({required this.count, required this.size});

  final int count;
  final double size;

  @override
  Widget build(Object context) {
    const shape = BoxShape.circle;
    final style = textStyle.copyWith(color: Colors.brown);

    Widget current = Text('$count', style: style);
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
