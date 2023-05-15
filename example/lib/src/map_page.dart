import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geo_map/geo_map.dart';

import '../env.dart';
import 'locations.dart';
import 'ui/bottom.dart';
import 'ui/cluster.dart';
import 'ui/marker.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _ctrl = MapCtrl();
  var _markers = allMarkers;
  var _debugMode = false;

  void _onTapSwitch() {
    if (_markers.length == 15) return setState(() => _markers = markers1);
    if (_markers == markers1) return setState(() => _markers = markers2);
    if (_markers == markers2) return setState(() => _markers = markers3);
    if (_markers == markers3) setState(() => _markers = allMarkers);
  }

  void _toggleDebugMode() => setState(() => _debugMode = !_debugMode);

  @override
  Widget build(BuildContext context) {
    Widget current = MyMap(
      ctrl: _ctrl,
      user: mapUser,
      styleId: mapStyleId,
      accessToken: mapAccessToken,
      gps: myGps,
      markers: _markers,
      debugMode: _debugMode,
      markerBuilder: (size) => Marker(size: size),
      clusterBuilder: (count, size) => Cluster(count: count, size: size),
    );

    current = Stack(
      children: [
        current,
        Bottom(
          ctrl: _ctrl,
          activeMarkers: _markers,
          onTapSwitch: _onTapSwitch,
          toggleDebugMode: _toggleDebugMode,
        ),
      ],
    );

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: topPadding(context)),
          Expanded(child: current),
        ],
      ),
    );
  }
}

double topPadding(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);

  double topPadding =
      (!kIsWeb && Platform.isMacOS) ? 28 : mediaQuery.padding.top;

  return topPadding;
}
