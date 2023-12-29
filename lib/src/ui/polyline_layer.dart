import 'package:flutter/widgets.dart';

import '../models/lat_lon.dart';
import '../models/pixel_point.dart';
import '../models/polyline.dart';

class PolylineLayer extends StatelessWidget {
  const PolylineLayer({
    required this.center,
    required this.polylines,
    required this.latLonToPixelPoint,
    super.key,
  });

  final PixelPoint center;
  final List<Polyline> polylines;
  final PixelPoint Function(LatLon) latLonToPixelPoint;

  @override
  Widget build(BuildContext context) {
    final fullSize = MediaQuery.of(context).size;
    final fullW = fullSize.width;
    final fullH = fullSize.height;

    final painter = _Painter(
      polylines: polylines,
      latLonToPixelPoint: latLonToPixelPoint,
    );

    Widget current = CustomPaint(painter: painter);

    return Positioned(
      left: (fullW / 2) - center.x,
      top: (fullH / 2) - center.y,
      child: current,
    );
  }
}

class _Painter extends CustomPainter {
  _Painter({
    required this.polylines,
    required this.latLonToPixelPoint,
  });

  final List<Polyline> polylines;
  final PixelPoint Function(LatLon) latLonToPixelPoint;

  @override
  void paint(Canvas canvas, Size size) {
    for (var polyline in polylines) {
      final points = polyline.points;

      final path = Path();

      for (var i = 0; i < points.length; i++) {
        final point = latLonToPixelPoint(points[i]);

        if (i == 0) path.moveTo(point.x, point.y);
        if (i == 0) continue;

        path.lineTo(point.x, point.y);
      }

      path.close();

      var paint = Paint()..color = polyline.color;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = polyline.width;

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
