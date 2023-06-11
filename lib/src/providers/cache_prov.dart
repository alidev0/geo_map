import 'package:shared_preferences/shared_preferences.dart';

import '../debug/map_log.dart';
import '../models/tile_point.dart';

/// CacheProvider
const cacheProvider = CacheProvider();

class CacheProvider {
  const CacheProvider();

  static const String _key = 'db13';
  static late String _onGoingKey;

  static late SharedPreferences _database;
  static SharedPreferences get database {
    return _database;
  }

  Future<void> init() async {
    try {
      _database = await SharedPreferences.getInstance();
      _onGoingKey = DateTime.now().millisecondsSinceEpoch.toString();
      mapLog.i('CacheProvider IS INIT');
    } catch (e) {
      mapLog.e(e, file: 'cache_prov/init');
    }
  }

  Future<void> setOnGoing(TilePoint tile) async {
    await _database.setBool('${_key}_${_onGoingKey}_${tile.key}', true);
  }

  bool isOnGoing(TilePoint tile) {
    return _database.getBool('${_key}_${_onGoingKey}_${tile.key}') ?? false;
  }

  Future<bool> clearOnGoing(TilePoint tile) async {
    return await _database.remove('${_key}_${_onGoingKey}_${tile.key}');
  }

  Future<void> setDown(TilePoint tile) async {
    await _database.setBool('${_key}_is_down_${tile.key}', true);
  }

  bool isDown(TilePoint tile) {
    return _database.getBool('${_key}_is_down_${tile.key}') ?? false;
  }
}
