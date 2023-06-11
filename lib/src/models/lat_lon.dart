/// LatLon
class LatLon {
  LatLon(this.lat, this.lon);
  double lat;
  double lon;

  @override
  String toString() {
    return 'lat: $lat, lon: $lon';
  }
}
