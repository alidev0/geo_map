import 'dart:math';

double _logBase(double x, double base) => log(x) / log(base);

double _log2(double x) => _logBase(x, 2);

double zoomToScale({
  required double zoom,
  required double zoomRef,
  required double scaleRef,
}) =>
    pow(2, zoom - zoomRef) * scaleRef;

double scaleToZoom({
  required double scale,
  required double zoomRef,
  required double scaleRef,
}) =>
    _log2(scale / scaleRef) + zoomRef;
