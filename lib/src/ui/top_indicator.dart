import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TopIndicator extends StatelessWidget {
  const TopIndicator({super.key, required this.tiles});

  final int tiles;

  double topPadding(BuildContext context) {
    final mQ = MediaQuery.of(context);
    return (!kIsWeb && Platform.isMacOS) ? 28 : mQ.padding.top;
  }

  @override
  Widget build(BuildContext context) {
    Widget current = Text(tiles.toString());
    return Positioned(top: topPadding(context), right: 4, child: current);
  }
}
