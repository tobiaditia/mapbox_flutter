import 'package:latlong2/latlong.dart';

class MapMarker {
  MapMarker({
    required this.id,
    required this.image,
    required this.title,
    required this.address,
    required this.location,
    required this.endLat,
    required this.endLng,
    this.userId = '',
    this.likedUser,
  });

  final String id;
  final String image;
  final String title;
  final String address;
  final LatLng location;
  final String endLat;
  final String endLng;
  String userId = '';
  List? likedUser = [];

  factory MapMarker.fromJson(Map<String, dynamic> json, String id) => MapMarker(
        id: id,
        image: json['image'],
        title: json['name'],
        address: json['address'],
        location: LatLng(double.parse(json['latitude'].toString()),
            double.parse(json['longitude'].toString())),
        endLat: json['latitude'].toString(),
        endLng: json['longitude'].toString(),
        userId: json['userId'],
        likedUser: json['likedUser'] ?? [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "title": title,
        "address": address,
        "location": location,
        "endLat": endLat,
        "endLng": endLng,
        "userId": userId,
        "likedUser": likedUser ?? [],
      };
}
