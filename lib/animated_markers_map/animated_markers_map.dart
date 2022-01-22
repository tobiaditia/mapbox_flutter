import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_flutter/animated_markers_map/map_marker.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoidG9iaWFkaXRpYSIsImEiOiJja2xqN2N2Znkxa29kMndvaTc0d2RxY3RwIn0.yxbbgWslbanpHwditeyYJw';
const MAPBOX_STYLE = 'mapbox/streets-v11';
const MAPBOX_COLOR = Color(0xFF3DC5A7);

final _myLocation = LatLng(-8.100000, 112.150002);

class AnimatedMarkersMap extends StatefulWidget {
  const AnimatedMarkersMap({Key? key}) : super(key: key);

  @override
  State<AnimatedMarkersMap> createState() => _AnimatedMarkersMapState();
}

class _AnimatedMarkersMapState extends State<AnimatedMarkersMap>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  int _selectedIndex = 0;
  late final AnimationController _animationController;

  List<Marker> _buildMarkers() {
    final _markerList = <Marker>[];
    for (var i = 0; i < mapMarkers.length; i++) {
      final mapItem = mapMarkers[i];
      _markerList.add(Marker(
          point: mapItem.location,
          builder: (_) {
            return GestureDetector(
              onTap: () {
                _selectedIndex = i;
                setState(() {
                  _pageController.animateToPage(i,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.elasticOut);
                });
              },
              child: _locationMarker(
                selected: _selectedIndex == i,
              ),
            );
          }));
    }
    return _markerList;
  }

  @override
  void initState() {
    // TODO: implement initState
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _markers = _buildMarkers();

    return Scaffold(
      appBar: AppBar(
        title: Text('Blitar Location'),
        actions: [
          IconButton(
              onPressed: () => null, icon: Icon(Icons.filter_alt_outlined))
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(minZoom: 5, zoom: 13, center: _myLocation),
            nonRotatedLayers: [
              TileLayerOptions(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                  additionalOptions: {
                    'accessToken': MAPBOX_ACCESS_TOKEN,
                    'id': MAPBOX_STYLE,
                  }),
              MarkerLayerOptions(markers: _markers),
              MarkerLayerOptions(markers: [
                Marker(
                    height: 50,
                    width: 50,
                    point: _myLocation,
                    builder: (_) {
                      return _MyLocationMarker(_animationController);
                    })
              ])
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            height: MediaQuery.of(context).size.height * .3,
            child: PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) {
                final item = mapMarkers[index];
                return _MapItemDetails(
                  mapMarker: item,
                );
              },
              itemCount: mapMarkers.length,
            ),
          )
        ],
      ),
    );
  }
}

class _MyLocationMarker extends AnimatedWidget {
  const _MyLocationMarker(Animation<double> animation, {Key? key})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final value = (listenable as Animation<double>).value;
    final size = 40.0;
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
            decoration:
                BoxDecoration(color: MAPBOX_COLOR, shape: BoxShape.circle),
          ),
        ),
      ],
    ));
  }
}

class _MapItemDetails extends StatelessWidget {
  const _MapItemDetails({Key? key, required this.mapMarker}) : super(key: key);
  final MapMarker mapMarker;

  @override
  Widget build(BuildContext context) {
    final _styleTitle = TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
    final _styleAddress = TextStyle(color: Colors.grey[800], fontSize: 14);
    return Padding(
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
                  Expanded(child: Image.asset(mapMarker.image)),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        mapMarker.title,
                        style: _styleTitle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        mapMarker.address,
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
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _locationMarker extends StatelessWidget {
  const _locationMarker({Key? key, this.selected = false}) : super(key: key);

  final bool selected;
  @override
  Widget build(BuildContext context) {
    final double size = selected ? 60 : 50;
    final Color color = selected ? Colors.red : Colors.blue;
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        child: Icon(
          Icons.location_on,
          size: size,
          color: color,
        ),
      ),
    );
  }
}
