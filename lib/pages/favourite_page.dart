import 'dart:async';

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

class FovouritePage extends StatefulWidget {
  const FovouritePage({Key? key}) : super(key: key);

  @override
  State<FovouritePage> createState() => FovouritePageState();
}

class FovouritePageState extends State<FovouritePage> {
  String query = '';
  late List<MapMarker> mapMarkers2 = [];
  var ref = FirebaseStorage.instance.ref().child('locations');
  Timer? debouncer;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() => isLoading = true);
    init().then((value) => setState(() => isLoading = false));
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    List<MapMarker> mapMarkers3 = await FirebaseServices()
        .getDataFromFireStoreToList(query: query, favourite: true);

    setState(() => this.mapMarkers2 = mapMarkers3);
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
              (isLoading)
                  ? CircularProgressIndicator()
                  : ((mapMarkers2.isEmpty)
                      ? Text('Data Tidak Ditemukan !')
                      : Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: mapMarkers2.length,
                              itemBuilder: (context, index) {
                                // FirebaseServices().getDataFromFireStoreToList();

                                return buildMapMarker(
                                    mapMarkers2[index], index);
                              }))),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
      text: query, hintText: "Nama Lokasi", onChanged: searchLocation);

  Future searchLocation(String query) async {
    setState(() => isLoading = true);
    debounce(() async {
      final mapMarkers3 = await FirebaseServices()
          .getDataFromFireStoreToList(query: query, favourite: true);

      if (!mounted) return;

      setState(() {
        this.query = query;
        this.mapMarkers2 = mapMarkers3;
        isLoading = false;
      });
    });
  }

  Widget buildMapMarker(MapMarker mapMarker, int index) => Container(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailMapPage(mapMarker: mapMarker)));
          },
          child: CardWidget(
              mapMarker: mapMarker,
              image: mapMarker.image,
              title: mapMarker.title),
        ),
      );
}
