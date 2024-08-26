import 'dart:math';

import '../constants/constants.dart';
import '../models/circle.dart';
import '../models/lat_lon.dart';
import '../models/marker.dart';
import '../models/pixel_point.dart';
import '../models/tile_point.dart';

/// find the map center after it has scaled
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

/// find the furtherst point from the center of group of points
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

/// find the centroid of the points (in pixel)
PixelPoint getCirclesPixelCentroid(List<Circle> circles) {
  final points = circles.map((e) => e.pixel).toList();
  return getPixelCentroid(points);
}

/// find the centroid of the points (in Circle)
Circle getCirclesCircleCentroid(List<Circle> circles) {
  final latLonPoints = circles.map((e) => e.latLng).toList();
  final pixelPoints = circles.map((e) => e.pixel).toList();

  return Circle(
    marker: Marker(latLon: getLanLonCentroid(latLonPoints)),
    pixel: getPixelCentroid(pixelPoints),
    clusterRad: circles.first.clusterRad,
  );
}

/// find the centroid of the points (in LatLon)
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

/// find the distance of 2 points
double getDistanceBtw2Points({
  required PixelPoint point1,
  required PixelPoint point2,
}) {
  return sqrt(
    pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2),
  );
}

/// find the center tile of the screen
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

/// find the size of the map for a specific zoom
double getMapScaleForZoom(double zoom) => pow(2, zoom - zoomRef).toDouble();

/// find the size of the unit for a specific zoom and scale
double getUnitSize({required double zoom, required double mapScale}) {
  final mapSize = getMapSize(mapScale: mapScale);
  return mapSize / pow(2, zoom);
}

/// find the size of the map for a specific scale
double getMapSize({required double mapScale}) =>
    mapScale * (sizeRef * pow(2, zoomRef));

/// convert angle to clockwise radians
/// Convert the angle from -180° to 180° to 0° to 360°
double degreeToRadian(double angle) {
  double positiveAngle = angle < 0 ? 360 + angle : angle;
  return positiveAngle * (pi / 180);
}
