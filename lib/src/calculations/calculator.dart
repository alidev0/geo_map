import 'dart:math';

import '../constants/constants.dart';
import '../models/circle.dart';
import '../models/lat_lon.dart';
import '../models/pixel_point.dart';
import '../models/tile_point.dart';

PixelPoint getNewCenterAfterScale({
  required double prevMapScale,
  required double newMapScale,
  required PixelPoint center,
}) {
  final scaleByCenter = prevMapScale / newMapScale;
  final x = center.x / scaleByCenter;
  final y = center.y / scaleByCenter;

  return PixelPoint(x, y);
}

Circle getFurthestCircle(List<Circle> circles) {
  final center = getCirclesPixelCentroid(circles);

  var index = 0;
  var refDistance = 0.0;

  for (var i = 0; i < circles.length; i++) {
    final circle = circles[i];

    final distance =
        getDistanceBtw2Points(point1: center, point2: circle.pixel);

    if (distance > refDistance) {
      refDistance = distance;
      index = i;
    }
  }

  return circles[index];
}

PixelPoint getCirclesPixelCentroid(List<Circle> circles) {
  final points = circles.map((e) => e.pixel).toList();
  return getPixelCentroid(points);
}

Circle getCirclesCircleCentroid(List<Circle> circles) {
  final latLonPoints = circles.map((e) => e.latLng).toList();
  final pixelPoints = circles.map((e) => e.pixel).toList();

  return Circle(
    latLng: getLanLonCentroid(latLonPoints),
    pixel: getPixelCentroid(pixelPoints),
    radius: circles.first.radius,
  );
}

LatLon getLanLonCentroid(List<LatLon> points) {
  double x = 0;
  double y = 0;
  int length = points.length;

  for (LatLon point in points) {
    x += point.lat;
    y += point.lon;
  }

  return LatLon(x / length, y / length);
}

/// <`PixelPoint`>[`points`] => `PixelPoint`
PixelPoint getPixelCentroid(List<PixelPoint> points) {
  double x = 0;
  double y = 0;
  int length = points.length;

  for (PixelPoint point in points) {
    x += point.x;
    y += point.y;
  }

  return PixelPoint(x / length, y / length);
}

double getDistanceBtw2Points({
  required PixelPoint point1,
  required PixelPoint point2,
}) {
  return sqrt(
    pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2),
  );
}

TilePoint getCenterTile({
  required PixelPoint center,
  required double zoom,
  required double mapScale,
}) {
  final newZoom = zoom.floorToDouble();
  final newScale = getMapScaleForZoom(newZoom);
  final newCenter = getNewCenterAfterScale(
      prevMapScale: mapScale, newMapScale: newScale, center: center);

  final unitSize = getUnitSize(zoom: newZoom, mapScale: newScale);

  final x = newCenter.x ~/ unitSize;
  final y = newCenter.y ~/ unitSize;

  return TilePoint(x, y, newZoom.toInt());
}

double getMapScaleForZoom(double zoom) => pow(2, zoom - zoomRef).toDouble();

double getUnitSize({required double zoom, required double mapScale}) {
  final mapSize = getMapSize(mapScale: mapScale);
  return mapSize / pow(2, zoom);
}

double getMapSize({required double mapScale}) =>
    mapScale * (sizeRef * pow(2, zoomRef));