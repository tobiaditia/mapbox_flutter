import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_flutter/models/direction_model.dart';
import 'package:mapbox_flutter/settings/application_settings.dart';
import 'package:http/http.dart' as http;

class MapWidget extends StatefulWidget {
  final String startLng;
  final String startLat;
  final String endLng;
  final String endLat;
  const MapWidget(
      {Key? key,
      required this.startLng,
      required this.startLat,
      required this.endLng,
      required this.endLat})
      : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late DirectionModel directionModel;

  final List<LatLng> coordinates = [];
  late final LatLng myLocation = LatLng(double.parse(widget.startLat),double.parse(widget.startLng));
  late final LatLng destination = LatLng(double.parse(widget.endLat),double.parse(widget.endLng));

  Future getDirection(
      {required String startLng,
      required String startLat,
      required String endLng,
      required String endLat}) async {
    String mode = 'driving';
    Uri url = Uri.parse(
        'https://api.mapbox.com/directions/v5/mapbox/${mode}/${startLng},${startLat};${endLng},${endLat}?geometries=geojson&access_token=${MAPBOX_ACCESS_TOKEN}');

    var response = await http.get(url);
    Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    directionModel = DirectionModel.fromJson(data);

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
            startLng: widget.startLng,
            startLat: widget.startLat,
            endLng: widget.endLng,
            endLat: widget.endLat),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('LOADING ....'),
            );
          }
          return Stack(
            children: [
              FlutterMap(
                options:
                    MapOptions(minZoom: 5, zoom: 13, center: destination),
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
                        points: coordinates, strokeWidth: 4.0, color: Colors.blue)
                  ]),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                height: MediaQuery.of(context).size.height * .3,
                child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Card(
                        margin: EdgeInsets.zero,
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: Image.asset('assets/animated_markers_map/Makam_Soekarno.jpg')),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                      child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'mapMarker.title',
                                        style: _styleTitle,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        'mapMarker.address',
                                        style: _styleAddress,
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            ),
                            MaterialButton(
                              onPressed: () => {},
                              color: MAPBOX_COLOR,
                              padding: EdgeInsets.zero,
                              elevation: 6,
                              child: Text(
                                'Go',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
              )
            ],
          );
        });
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
