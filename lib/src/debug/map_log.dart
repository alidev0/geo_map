import 'package:flutter/material.dart';

/// MapLog
const mapLog = MapLog();

class MapLog {
  const MapLog();

  static bool debugMode = false;

  void e(dynamic value, {String? file}) {
    if (!debugMode) return;
    if (file != null) debugPrint('MAP ELog: File: $file');
    debugPrint('MAP ELog: $value');
  }

  void i(dynamic value) {
    if (!debugMode) return;
    debugPrint('MAP ILog: $value');
  }
}
