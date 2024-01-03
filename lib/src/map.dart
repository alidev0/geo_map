import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'calculations/calculator.dart';
import 'calculations/lat_lon_cal.dart';
import 'calculations/zoom_scale.dart';
import 'constants/constants.dart';
import 'debug/debug_w.dart';
import 'debug/map_log.dart';
import 'marker_layer/marker_layer.dart';
import 'models/circle.dart';
import 'models/lat_lon.dart';
import 'models/marker.dart';
import 'models/pixel_point.dart';
import 'models/polyline.dart';
import 'models/tile_point.dart';
import 'providers/main_prov.dart';
import 'providers/tile_prov.dart';
import 'tiles/tile.dart';
import 'tiles/tile_manager.dart';
import 'ui/ctrl.dart';
import 'ui/helper.dart';
import 'ui/my_animated.dart';
import 'ui/my_location.dart';
import 'ui/polyline_layer.dart';
import 'ui/top_indicator.dart';

/// ptwcode map
class PTWCodeMap extends StatefulWidget {
  const PTWCodeMap({
    required this.ctrl,
    super.key,
    this.markers,
    this.markerBuilder,
    this.enableCluster = false,
    this.clusterBuilder,
    required this.user,
    required this.styleId,
    required this.accessToken,
    this.debugMode = false,
    this.gps,
    this.polylines,
  });

  final MapCtrl ctrl;
  final List<Marker>? markers;
  final Widget Function(double, Map<String, dynamic>?)? markerBuilder;
  final bool enableCluster;
  final Widget Function(int count, double size)? clusterBuilder;
  final String user;
  final String styleId;
  final String accessToken;
  final bool debugMode;
  final LatLon? gps;
  final List<Polyline>? polylines;

  @override
  State<PTWCodeMap> createState() => _PTWCodeMapState();
}

class _PTWCodeMapState extends State<PTWCodeMap> {
  late MyAnimatedCtrl _ctrl;

  List<TilePoint> _loadedTiles = [];

  var _zoom = 0.0;
  var _mapScale = 1.0;
  PixelPoint _center = PixelPoint(800, 600);

  var _scaleMode = 1.0;
  var _dragMode = const Offset(0, 0);

  var _prevScale = 0.0;
  late LatLon _animToLatLon;
  List<double> _zoomAnimFromTo = [];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.ctrl.animateTo = _animateTo;
    SchedulerBinding.instance.addPostFrameCallback((_) => _buildCallback());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  void _buildCallback() async {
    await mainProvider.init(
      user: widget.user,
      styleId: widget.styleId,
      accessToken: widget.accessToken,
    );
    if (!mounted) return;

    _zoom = zoomRef;
    _prevScale = _mapScale;
    _timer = Timer.periodic(const Duration(milliseconds: 333), _periodicFire);
  }

  void _periodicFire(Timer _) async {
    if (_zoomAnimFromTo.isNotEmpty) return;
    tileProvider.downloadAll(_loadedTiles);
    _loadedTiles = await tileManager(
      center: _center,
      scale: _mapScale,
      zoom: _zoom,
      mapScale: _mapScale,
      markers: widget.markers?.map((el) => el.latLon).toList(),
      gps: widget.gps,
    );
    setState(() {});
  }

  void _animateTo(LatLon latLon, double zoom) {
    _animToLatLon = latLon;
    _zoomAnimFromTo = [_zoom, zoom];
    _ctrl.forward();
  }

  void _animateFromCircles(List<Circle> circles) {
    final distance = getDistanceBtw2Points(
      point1: circles.first.pixel,
      point2: circles.last.pixel,
    );

    /// (clusterRadius / distance) with how much scale does point need to get out of center radius
    final scale = _mapScale * ((clusterRadius * 2.5) / distance);
    final zoom =
        scaleToZoom(scale: scale, zoomRef: zoomRef, scaleRef: scaleRef);

    _animateTo(circles.last.latLng, zoom);
  }

  PixelPoint _latLonToPixelPoint(LatLon latLon) =>
      latLonToPixelPoint(latLon: latLon, mapScale: _mapScale);

  void _boundCheck() {
    final fullSize = MediaQuery.of(context).size;
    final fullW = fullSize.width;
    final halfW = fullW / 2;
    final fullH = fullSize.height;
    final halfH = fullH / 2;

    final mapSize = getMapSize(mapScale: _mapScale);

    if (_center.x - (fullW / 2) < 0) _center.x = fullW / 2;
    if (_center.y - (fullH / 2) < 0) _center.y = fullH / 2;
    if (_center.x + halfW > mapSize) _center.x = mapSize - halfW;
    if (_center.y + halfH > mapSize) _center.y = mapSize - halfH;
  }

  bool get _canShrink {
    if (_zoom <= 3.1) return false;
    final fullSize = MediaQuery.of(context).size;
    final mapSize = getMapSize(mapScale: _mapScale);
    return mapSize - 8 >= fullSize.height;
  }

  void _keepCenterWhenScaling() {
    final scaleBy = _prevScale / _mapScale;
    _center = PixelPoint(_center.x / scaleBy, _center.y / scaleBy);
    _prevScale = _mapScale;
  }

  @override
  Widget build(BuildContext context) {
    MapLog.debugMode = widget.debugMode;

    if (_loadedTiles.length < 10) {
      return const Center(child: CircularProgressIndicator());
    }

    final markers = widget.markers;
    final polylines = widget.polylines;

    return MyAnimated(
      reset: true,
      onBuild: (ctrl) => _ctrl = ctrl,
      onDone: () {
        _zoom =  _zoomAnimFromTo.last;
        _zoomAnimFromTo = [];
      },
      builder: (anim) {
        if (_zoomAnimFromTo.isNotEmpty) {
          _zoom =
              lerpDouble(_zoomAnimFromTo.first, _zoomAnimFromTo.last, anim)!;
          _mapScale =
              zoomToScale(scaleRef: scaleRef, zoom: _zoom, zoomRef: zoomRef);

          _keepCenterWhenScaling();

          final centerAnimTo = _latLonToPixelPoint(_animToLatLon);
          _center.x = lerpDouble(_center.x, centerAnimTo.x, anim)!;
          _center.y = lerpDouble(_center.y, centerAnimTo.y, anim)!;
        }

        Widget current = Stack(
          children: [
            ..._loadedTiles
                .map((model) => PositionedTile(zoom: _zoom, tile: model))
                .toList(),
            if (widget.gps != null)
              MyLocation(pixelPoint: _latLonToPixelPoint(widget.gps!)),
            if (markers != null)
              MarkerLayer(
                animateFromCircles: _animateFromCircles,
                markerBuilder: widget.markerBuilder,
                enableCluster: widget.enableCluster,
                clusterBuilder: widget.clusterBuilder,
                markers: markers,
              ),
            TopIndicator(tiles: _loadedTiles.length),
            if (MapLog.debugMode)
              DebugW(
                sizeRef: sizeRef,
                zoomRef: zoomRef,
                zoom: _zoom,
                loadedTiles: _loadedTiles,
              ),
            if (polylines != null) PolylineLayer(polylines: polylines),
          ],
        );

        current = GestureDetector(
          onScaleStart: (data) {
            _dragMode = data.focalPoint;
            _scaleMode = 1.0;
          },
          onScaleUpdate: (data) {
            if (_zoomAnimFromTo.isNotEmpty) return;

            /// panning
            if (data.scale != 1.0) {
              final scaleBy = _scaleMode - data.scale;
              // prevent touch disturbances
              if (scaleBy.abs() < 0.024) return;
              // check zoom bounds
              final expand = scaleBy < 0;
              final shrink = !expand;
              if (shrink && !_canShrink) return;

              _mapScale = expand ? _mapScale * 1.02 : _mapScale / 1.02;
              _zoom = scaleToZoom(
                  scale: _mapScale, zoomRef: zoomRef, scaleRef: scaleRef);

              _keepCenterWhenScaling();

              _scaleMode = data.scale;
              _prevScale = _mapScale;
              _boundCheck();
            }

            /// dragging
            if (data.scale == 1.0) {
              final dragByX = data.focalPoint.dx - _dragMode.dx;
              if (dragByX < 0) _center.x += dragByX.abs();
              if (dragByX > 0) _center.x -= dragByX.abs();

              final dragByY = data.focalPoint.dy - _dragMode.dy;
              if (dragByY < 0) _center.y += dragByY.abs();
              if (dragByY > 0) _center.y -= dragByY.abs();

              _boundCheck();
              _dragMode = data.focalPoint;
            }
            setState(() {});
          },
          onDoubleTap: () {
            if (_zoomAnimFromTo.isNotEmpty) return;
            _zoom++;
            _mapScale = _mapScale * 2;
            _keepCenterWhenScaling();
            _boundCheck();
            setState(() {});
          },
          child: current,
        );

        return Helper(mapScale: _mapScale, center: _center, child: current);
      },
    );
  }
}
