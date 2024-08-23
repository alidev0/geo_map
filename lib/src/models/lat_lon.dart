/// LatLon
class LatLon {
  LatLon(this.lat, this.lon, {this.heading});
  double lat;
  double lon;
  double? heading;

  @override
  String toString() {
    return 'lat: $lat, lon: $lon, heading: $heading';
  }
}
