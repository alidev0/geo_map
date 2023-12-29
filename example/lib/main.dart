import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ptwcode_map/ptwcode_map.dart';

import 'env.dart';
import 'locations.dart';
import 'ui/bottom.dart';
import 'ui/cluster.dart';
import 'ui/marker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _ctrl = MapCtrl();
  var _markers = allMarkers;
  var _pLines = allPolylines;
  var _debugMode = false;

  void _onTapSwitchMarkers() {
    if (_markers.length == 15) return setState(() => _markers = markers1);
    if (_markers == markers1) return setState(() => _markers = markers2);
    if (_markers == markers2) return setState(() => _markers = markers3);
    if (_markers == markers3) setState(() => _markers = allMarkers);
  }

  void _toggleDebugMode() => setState(() => _debugMode = !_debugMode);

  void _onTapSwitchLines() {
    if (_pLines.length == 3) return setState(() => _pLines = polylines1);
    if (_pLines == polylines1) return setState(() => _pLines = polylines2);
    if (_pLines == polylines2) return setState(() => _pLines = polylines3);
    if (_pLines == polylines3) setState(() => _pLines = allPolylines);
  }

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
      polylines: _pLines,
    );

    current = Stack(
      children: [
        current,
        Bottom(
          ctrl: _ctrl,
          activeMarkers: _markers,
          onTapSwitchMarkers: _onTapSwitchMarkers,
          toggleDebugMode: _toggleDebugMode,
          onTapSwitchLines: _onTapSwitchLines,
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
  final mQ = MediaQuery.of(context);
  return (!kIsWeb && Platform.isMacOS) ? 28 : mQ.padding.top;
}
