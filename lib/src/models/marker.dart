import 'lat_lon.dart';

class Marker {
  Marker({required this.latLon, this.data});

  final LatLon latLon;
  final Map<String, dynamic>? data;

  @override
  String toString() {
    return '$latLon, $data';
  }
}
