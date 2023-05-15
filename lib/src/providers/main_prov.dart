import 'cache_prov.dart';
import 'directory_prov.dart';
import 'tile_prov.dart';

const mainProvider = MainProvider();

class MainProvider {
  const MainProvider();

  Future<void> init({
    required String user,
    required String styleId,
    required String accessToken,
  }) async {
    if (DirectoryProvider.isInit) return;

    await directoryProvider.init();
    tileProvider.init(user: user, styleId: styleId, accessToken: accessToken);
    await cacheProvider.init();
  }
}
