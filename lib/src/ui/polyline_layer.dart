import 'package:flutter/widgets.dart';

import '../calculations/lat_lon_cal.dart';
import '../models/pixel_point.dart';
import '../models/polyline.dart';
import 'helper.dart';

class PolylineLayer extends StatelessWidget {
  const PolylineLayer({super.key, required this.polylines});
  final List<Polyline> polylines;

  @override
  Widget build(BuildContext context) {
    final fullSize = Helper.sizeOf(context);

    final painter = _Painter(context, fullSize: fullSize, polylines: polylines);
    return CustomPaint(painter: painter);
  }
}

class _Painter extends CustomPainter {
  _Painter(this.context, {required this.fullSize, required this.polylines});

  final BuildContext context;
  final Size fullSize;
  final List<Polyline> polylines;

  @override
  void paint(Canvas canvas, Size size) {
    final fullW = fullSize.width;
    final fullH = fullSize.height;
    final mapScale = Helper.mapScaleOf(context);
    final center = Helper.centerOf(context);

    for (var polyline in polylines) {
      final points = polyline.points;

      final path = Path();

      for (var i = 0; i < points.length; i++) {
        final fullP = latLonToPixelPoint(latLon: points[i], mapScale: mapScale);

        final point = PixelPoint(
          fullP.x - (center.x - (fullW / 2)),
          fullP.y - (center.y - (fullH / 2)),
        );

        if (i == 0) path.moveTo(point.x, point.y);
        if (i == 0) continue;

        path.lineTo(point.x, point.y);
      }

      if (polyline.close) path.close();

      var paint = Paint()..color = polyline.color;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = polyline.width;

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
