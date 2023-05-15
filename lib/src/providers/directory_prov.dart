import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../debug/map_log.dart';

const directoryProvider = DirectoryProvider();

class DirectoryProvider {
  const DirectoryProvider();

  static String _directory = '';
  static String get directory {
    if (_directory.isEmpty) mapLog.e('DirectoryProvider NO INIT');
    return _directory;
  }

  static bool isInit = _directory.isNotEmpty;

  Future<void> init() async {
    try {
      final main = (await getApplicationDocumentsDirectory()).path;
      final dir = await Directory('$main/map_files').create(recursive: true);
      _directory = dir.path;
      mapLog.i('DirectoryProvider IS INIT');
    } catch (e) {
      mapLog.e(e, file: 'directory_prov/init');
    }
  }
}
