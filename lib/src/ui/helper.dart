import 'package:flutter/widgets.dart';

import '../models/pixel_point.dart';

class Helper extends InheritedWidget {
  const Helper({
    Key? key,
    required this.mapScale,
    required this.center,
    required this.size,
    required Widget child,
  }) : super(key: key, child: child);

  final double mapScale;
  final PixelPoint center;
  final Size size;

  static double mapScaleOf(BuildContext context) => _result(context).mapScale;
  static PixelPoint centerOf(BuildContext context) => _result(context).center;
  static Size sizeOf(BuildContext context) => _result(context).size;

  static Helper _result(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Helper>();
    assert(result != null, 'No $Helper found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(Helper oldWidget) => oldWidget.mapScale != mapScale;
}
