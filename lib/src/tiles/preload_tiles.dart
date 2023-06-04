import '../../ptwcode_map.dart';
import '../models/tile_point.dart';
import '../providers/tile_prov.dart';
import 'tile_manager.dart';

void preloadTiles(List<LatLon> locations) async {
  List<TilePoint> tiles = zoom3Tiles();

  final markerTiles = getMarkerTiles(markers: locations);

  tiles.addAll(markerTiles);
  tiles = tiles.toSet().toList();
  tileProvider.downloadAll(tiles);
}
