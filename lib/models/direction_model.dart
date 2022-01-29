class DirectionModel {
  List coordinates;
  double distance;
  double duration;
  DirectionModel(
      {required this.coordinates,
      required this.distance,
      required this.duration});

  factory DirectionModel.fromJson(Map<String, dynamic> json) => DirectionModel(
        coordinates: json['routes'][0]['geometry']['coordinates'],
        distance: json['routes'][0]['distance'],
        duration: json['routes'][0]['duration'],
      );

  Map<String, dynamic> toJson() => {
        "distance": coordinates,
        "coordinates": coordinates,
        "duration": duration
      };
}
