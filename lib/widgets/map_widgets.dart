import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_flutter/models/direction_model.dart';
import 'package:mapbox_flutter/models/map_marker.dart';
import 'package:mapbox_flutter/settings/application_settings.dart';
import 'package:http/http.dart' as http;

class MapWidget extends StatefulWidget {
  final MapMarker mapMarker;
  const MapWidget({Key? key, required this.mapMarker}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late DirectionModel directionModel;

  final List<LatLng> coordinates = [];
  late final LatLng myLocation;
  late final LatLng destination = LatLng(double.parse(widget.mapMarker.endLat),
      double.parse(widget.mapMarker.endLng));
  double distance = 0.0;
  int duration = 0;

  Position? _currentPosition;
  MapController _mapController = MapController();

  Future getDirection({
    required String endLng,
    required String endLat,
  }) async {
    await _determinePosition();
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true);
      _currentPosition = position;
      myLocation = LatLng(position.latitude, position.longitude);
    } catch (e) {}

    String mode = 'driving';
    Uri url = Uri.parse(
        'https://api.mapbox.com/directions/v5/mapbox/${mode}/${_currentPosition!.longitude.toString()},${_currentPosition!.latitude.toString()};${endLng},${endLat}?geometries=geojson&access_token=${MAPBOX_ACCESS_TOKEN}');

    var response = await http.get(url);
    Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    directionModel = DirectionModel.fromJson(data);
    distance = convertToKm(directionModel.distance);
    duration = Duration(seconds: directionModel.duration.toInt()).inMinutes;
    for (var coordinate in directionModel.coordinates) {
      coordinates.add(LatLng(coordinate[1], coordinate[0]));
    }
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _styleTitle = TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
    final _styleAddress = TextStyle(color: Colors.grey[800], fontSize: 14);
    return FutureBuilder(
        future: getDirection(
            endLng: widget.mapMarker.endLng, endLat: widget.mapMarker.endLat),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('LOADING ....'),
            );
          }
          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(minZoom: 5, zoom: 13, center: destination),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                      additionalOptions: {
                        'accessToken': MAPBOX_ACCESS_TOKEN,
                        'id': MAPBOX_STYLE,
                      }),
                  MarkerLayerOptions(markers: [
                    Marker(
                        height: 50,
                        width: 50,
                        point: myLocation,
                        builder: (_) {
                          return _MyLocationMarker(_animationController);
                        })
                  ]),
                  MarkerLayerOptions(markers: [
                    Marker(
                        height: 50,
                        width: 50,
                        point: destination,
                        builder: (_) {
                          return Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              child: const Icon(
                                Icons.location_on,
                                size: 50,
                                color: Colors.red,
                              ),
                            ),
                          );
                        })
                  ]),
                  PolylineLayerOptions(polylines: [
                    Polyline(
                        points: coordinates,
                        strokeWidth: 4.0,
                        color: Colors.blue)
                  ]),
                ],
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20,
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ExpandableNotifier(
                          child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: <Widget>[
                              // SizedBox(
                              //   height: 150,
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       color: Colors.orange,
                              //       shape: BoxShape.rectangle,
                              //     ),
                              //   ),
                              // ),
                              ScrollOnExpand(
                                scrollOnExpand: true,
                                scrollOnCollapse: false,
                                child: ExpandablePanel(
                                  theme: const ExpandableThemeData(
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.center,
                                    tapBodyToCollapse: true,
                                  ),
                                  header: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        widget.mapMarker.title,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,),
                                      )),
                                  collapsed: Text(
                                    widget.mapMarker.address,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  expanded: Table(
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      defaultColumnWidth:
                                          FractionColumnWidth(.50),
                                      border: TableBorder.all(),
                                      children: [
                                        TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Jarak'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                '${distance.toString()} KM'),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Durasi'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                '${duration.toString()} menit'),
                                          ),
                                        ]),
                                      ]),
                                  builder: (_, collapsed, expanded) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: Expandable(
                                        collapsed: collapsed,
                                        expanded: expanded,
                                        theme: const ExpandableThemeData(
                                            crossFadePoint: 0),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))))
            ],
          );
        });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}

class _MyLocationMarker extends AnimatedWidget {
  const _MyLocationMarker(Animation<double> animation, {Key? key})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final value = (listenable as Animation<double>).value;
    const size = 40.0;
    return Center(
        child: Stack(
      children: [
        Center(
          child: Container(
            height: size * value,
            width: size * value,
            decoration: BoxDecoration(
                color: MAPBOX_COLOR.withOpacity(.5), shape: BoxShape.circle),
          ),
        ),
        Center(
          child: Container(
            height: 20,
            width: 20,
            decoration: const BoxDecoration(
                color: MAPBOX_COLOR, shape: BoxShape.circle),
          ),
        ),
      ],
    ));
  }
}

double convertToKm(double meter) {
  double distanceInKiloMeters = meter / 1000;
  double roundDistanceInKM =
      double.parse((distanceInKiloMeters).toStringAsFixed(2));

  print(distanceInKiloMeters);
  print(roundDistanceInKM);
  return roundDistanceInKM;
}
