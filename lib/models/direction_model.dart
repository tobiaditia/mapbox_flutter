class DirectionModel {
  List coordinates;
  double distance;
  double duration;
  DirectionModel(
      {required this.coordinates,
      required this.distance,
      required this.duration});

  factory DirectionModel.fromJson(Map<String, dynamic> json) => DirectionModel(
        coordinates: json['routes'][0]['geometry']['coordinates'] ?? [],
        distance: json['routes'][0]['distance'].toDouble() ,
        duration: json['routes'][0]['duration'].toDouble() ,
      );

  Map<String, dynamic> toJson() => {
        "distance": coordinates,
        "coordinates": coordinates,
        "duration": duration
      };
}
