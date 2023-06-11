import 'dart:math';

/// _logBase
double _logBase(double x, double base) => log(x) / log(base);

/// _log2
double _log2(double x) => _logBase(x, 2);

/// zoomToScale
double zoomToScale({
  required double zoom,
  required double zoomRef,
  required double scaleRef,
}) =>
    pow(2, zoom - zoomRef) * scaleRef;

/// scaleToZoom
double scaleToZoom({
  required double scale,
  required double zoomRef,
  required double scaleRef,
}) =>
    _log2(scale / scaleRef) + zoomRef;
