import '../debug/map_log.dart';
import '../models/lat_lon.dart';
import '../providers/main_prov.dart';
import '../tiles/preload_tiles.dart';

/// MapCtrl
class MapCtrl {
  /// animate to a location
  late void Function(LatLon, double) animateTo;

  /// preload tiles for your locations
  static void preload({
    required String user,
    required String styleId,
    required String accessToken,
    required List<LatLon> locations,
    bool debugMode = false,
  }) async {
    MapLog.debugMode = debugMode;

    await mainProvider.init(
      user: user,
      styleId: styleId,
      accessToken: accessToken,
    );

    preloadTiles(locations);
  }
}
