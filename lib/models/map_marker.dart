import 'package:latlong2/latlong.dart';

class MapMarker {
  const MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
    required this.endLat,
    required this.endLng,
  });

  final String image;
  final String title;
  final String address;
  final LatLng location;
  final String endLat;
  final String endLng;
}

final List<LatLng> locations = [
  LatLng(-8.084429972199272, 112.17616549859079),
  LatLng(-8.091414087602997, 112.1657724102353),
  LatLng(-8.097868769661954, 112.1762536814),
  LatLng(-8.096028553213632, 112.17445496790643),
  LatLng(-8.112557814571403, 112.1575374985911),
  LatLng(-8.098927823098684, 112.166434098591),
  LatLng(-8.093765745109062, 112.17719081208423),
  LatLng(-8.084879739261629, 112.17558149859069),
  LatLng(-8.097848200762153, 112.16429469674203),
  LatLng(-8.097904569684543, 112.16518469674199),
];

const _path = 'assets/animated_markers_map/';

final mapMarkers = [
  MapMarker(
      image: '${_path}Makam_Soekarno.jpg',
      title: 'Bungkarno Graves',
      address: 'Blitar',
      location: locations[0],
      endLat: '-8.084429972199272',
      endLng: '112.17616549859079'),
  MapMarker(
      image: '${_path}Makam_Soekarno.jpg',
      title: 'Sumber Udel Waterpark',
      address: 'Blitar',
      location: locations[1],
      endLat: '-8.091414087602997',
      endLng: '112.1657724102353'),
  MapMarker(
      image: '${_path}Makam_Soekarno.jpg',
      title: 'Istana Gebang Blitar',
      address: 'Blitar',
      location: locations[2],
      endLat: '-8.097868769661954',
      endLng: '112.1762536814'),
  MapMarker(
      image: '${_path}Makam_Soekarno.jpg',
      title: 'Kebon Rojo Park',
      address: 'Blitar',
      location: locations[3],
      endLat: '-8.096028553213632',
      endLng: '112.17445496790643'),
  MapMarker(
      image: '${_path}Makam_Soekarno.jpg',
      title: 'Petik Belimbing Karangsari',
      address: 'Blitar',
      location: locations[4],
      endLat: '-8.112557814571403',
      endLng: '112.1575374985911'),
  MapMarker(
      image: '${_path}Makam_Soekarno.jpg',
      title: 'Taman Pecut',
      address: 'Blitar',
      location: locations[5],
      endLat: '-8.098927823098684',
      endLng: '112.166434098591'),
  MapMarker(
      image: '${_path}Makam_Soekarno.jpg',
      title: 'Monumen PETA',
      address: 'Blitar',
      location: locations[6],
      endLat: '-8.093765745109062',
      endLng: '112.17719081208423'),
  MapMarker(
      image: '${_path}Makam_Soekarno.jpg',
      title: 'Gong Perdamaian Dunia',
      address: 'Blitar',
      location: locations[7],
      endLat: '-8.084879739261629',
      endLng: '112.17558149859069'),
  MapMarker(
      image: '${_path}Makam_Soekarno.jpg',
      title: 'Masjid Agung',
      address: 'Blitar',
      location: locations[8],
      endLat: '-8.097848200762153',
      endLng: '112.16429469674203'),
  MapMarker(
      image: '${_path}Makam_Soekarno.jpg',
      title: 'Alun-Alun Kota Blitar',
      address: 'Blitar',
      location: locations[9],
      endLat: '-8.097904569684543',
      endLng: '112.16518469674199')
];
