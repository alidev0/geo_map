import 'package:ptwcode_map/ptwcode_map.dart';

final myGps = LatLon(41.318340, 19.824007);

final allMarkers = [
  tirana1Location,
  tirana2Location,
  tirana3Location,
  prishtinaLocation,
  shkupLocation,
  berlinLocation,
  romeLocation,
  parisLocation,
  lisbonLocation,
  budapestLocation,
  londonLocation,
  viennaLocation,
  istanbulLocation,
  madridLocation,
  stockholmLocation,
];

final markers1 = allMarkers.sublist(0, 5);
final markers2 = allMarkers.sublist(5, 10);
final markers3 = allMarkers.sublist(10, 15);

final tirana1Location = LatLon(41.329083, 19.815801);
final tirana2Location = LatLon(41.332933, 19.804448);
final tirana3Location = LatLon(41.336101, 19.816846);
final prishtinaLocation = LatLon(42.660955, 21.158010);
final shkupLocation = LatLon(41.995844, 21.433291);
final berlinLocation = LatLon(52.502359, 13.401914);
final romeLocation = LatLon(41.903181, 12.497422);
final madridLocation = LatLon(40.413828, -3.681696);
final parisLocation = LatLon(48.877796, 2.340852);
final londonLocation = LatLon(51.484836, -0.084675);
final viennaLocation = LatLon(48.210980, 16.374973);
final istanbulLocation = LatLon(41.037110, 28.980087);
final budapestLocation = LatLon(47.489911, 19.060254);
final lisbonLocation = LatLon(38.787783, -9.154827);
final stockholmLocation = LatLon(59.316027, 18.081135);
