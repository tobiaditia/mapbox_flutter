import 'package:animated_type_ahead_searchbar/animated_type_ahead_searchbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_flutter/models/map_marker.dart';
import 'package:mapbox_flutter/pages/detail_map_pages.dart';
import 'package:mapbox_flutter/services/firebase_services.dart';
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
  var ref = FirebaseStorage.instance.ref().child('locations');

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
                child: FutureBuilder<QuerySnapshot<Object?>>(
                    future: FirebaseServices().getDataFromFireStore(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      var locations = snapshot.data!.docs;
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: locations.length,
                          itemBuilder: (context, index) {
                            // var url2 = FirebaseServices()
                            //     .getImageFromFireStorage(
                            //         locations[index].get('image'));
                            FirebaseServices().getDataFromFireStoreToList();
                            final mapMarker = MapMarker(
                                image: locations[index].get('image'),
                                title: locations[index].get('name'),
                                address: locations[index].get('address'),
                                location: LatLng(
                                    -8.084429972199272, 112.17616549859079),
                                endLat: '-8.084429972199272',
                                endLng: '112.17616549859079');

                            print(mapMarker.image);
                            return buildMapMarker(mapMarker, index);
                          });
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
                builder: (context) => DetailMapPage(mapMarker: mapMarker)));
          },
          child: CardWidget(image: mapMarker.image, title: mapMarker.title),
        ),
      );
}
