import '../calculations/calculator.dart';
import 'lat_lon.dart';
import 'pixel_point.dart';

class Circle {
  Circle({required this.latLng, required this.pixel, required this.radius});

  LatLon latLng;
  PixelPoint pixel;
  double radius;

  bool intersects(Circle circle) {
    final distance = getDistanceBtw2Points(point1: circle.pixel, point2: pixel);
    final radiusSum = radius * 2;
    return distance <= radiusSum;
  }

  bool isEqual(Circle circle) {
    return circle.pixel.x == pixel.x && circle.pixel.y == pixel.y;
  }

  bool isEqualByPixel(PixelPoint point) {
    return point.x == pixel.x && point.y == pixel.y;
  }

  @override
  String toString() {
    return '${pixel.x}, ${pixel.y}, $radius';
  }

  // public bool Contains(Circle circle)
  // {
  //     if (circle.Radius > Radius)
  //         return false;
  //     float distanceX = Center.X - circle.Center.X;
  //     float distanceY = Center.Y - circle.Center.Y;
  //     float radiusD = Radius - circle.Radius;
  //     return distanceX * distanceX + distanceY * distanceY <= radiusD * radiusD;
  // }
}
