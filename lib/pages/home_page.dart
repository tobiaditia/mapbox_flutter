import 'package:animated_type_ahead_searchbar/animated_type_ahead_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_flutter/models/map_marker.dart';
import 'package:mapbox_flutter/pages/detail_map_pages.dart';
import 'package:mapbox_flutter/widgets/card_widget.dart';
import 'package:mapbox_flutter/widgets/search_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String query = '';
  late List<MapMarker> mapMarkers2;

  @override
  void initState() {
    super.initState();

    mapMarkers2 = mapMarkers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              buildSearch(),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: mapMarkers2.length,
                    itemBuilder: (context, index) {
                      final mapMarker = mapMarkers2[index];

                      return buildMapMarker(mapMarker, index);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
      text: query, hintText: "Nama Lokasi", onChanged: searchLocation);

  void searchLocation(String query) {
    final mapMarkers3 = mapMarkers.where((mapMarker) {
      final titleLower = mapMarker.title.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.mapMarkers2 = mapMarkers3;
    });
  }

  Widget buildMapMarker(MapMarker mapMarker, int index) => Container(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    DetailMapPage(mapMarker: mapMarkers2[index])));
          },
          child: CardWidget(
              image: mapMarkers2[index].image, title: mapMarkers2[index].title),
        ),
      );
}
