
class DirectionModel {
  List coordinates;
  DirectionModel({required this.coordinates});

  factory DirectionModel.fromJson(Map<String, dynamic> json) =>
      DirectionModel(coordinates: json['routes'][0]['geometry']['coordinates']);

  Map<String, dynamic> toJson() => {"coordinates": coordinates};
}
