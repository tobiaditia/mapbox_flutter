import 'dart:async';

import 'package:animated_type_ahead_searchbar/animated_type_ahead_searchbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_flutter/models/map_marker.dart';
import 'package:mapbox_flutter/pages/detail_map_pages.dart';
import 'package:mapbox_flutter/services/firebase_services.dart';
import 'package:mapbox_flutter/widgets/card_widget.dart';
import 'package:mapbox_flutter/widgets/search_widget.dart';

class FovouritePage extends StatefulWidget {
  const FovouritePage({Key? key}) : super(key: key);

  @override
  State<FovouritePage> createState() => _FovouritePageState();
}

class _FovouritePageState extends State<FovouritePage> {
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
    if (FirebaseAuth.instance.currentUser != null) {
      List<MapMarker> mapMarkers3 = await FirebaseServices()
          .getDataFromFireStoreToList(query: query, favourite: true);

      setState(() => this.mapMarkers2 = mapMarkers3);
    }
  }

  Future refresh() async {
    this.mapMarkers2 = [];
    List<MapMarker> mapMarkers3 = await FirebaseServices()
        .getDataFromFireStoreToList(query: query, favourite: true);

    setState(() {
      this.mapMarkers2 = mapMarkers3;
      isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
        content: Text('Berhasil Update Data !'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: (FirebaseAuth.instance.currentUser != null)
            ? Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Disukai & Pribadi',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color(0xff504F5E)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    buildSearch(),
                    SizedBox(
                      height: 20,
                    ),
                    (isLoading)
                        ? CircularProgressIndicator()
                        : ((mapMarkers2.isEmpty)
                            ? Text('Data Tidak Ditemukan !')
                            : Expanded(
                                child: ListView(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: mapMarkers2
                                    .map((e) => buildMapMarker(e))
                                    .toList(),
                              ))),
                  ],
                ),
              )
            : Center(
                child: Text('Harus Login Dahulu !'),
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

  Widget buildMapMarker(MapMarker mapMarker) => Container(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailMapPage(mapMarker: mapMarker)));
          },
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: 150,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(mapMarker.image, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.blue.shade900.withOpacity(.6),
                                  Colors.transparent,
                                ]))),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Text(mapMarker.title,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18))
                        ],
                      ),
                    ),
                  ),
                  (FirebaseAuth.instance.currentUser != null)
                      ? Positioned(
                          top: 0,
                          right: 0,
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isLoading = true;
                                    liked(mapMarker);
                                  });
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[200],
                                      border: Border.all(
                                          color: Colors.grey.shade500,
                                          width: 1)),
                                  child: Icon(
                                    Icons.favorite,
                                    color: (mapMarker.likedUser!.contains(
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                                .toString()))
                                        ? Colors.pink
                                        : Colors.black,
                                    size: 17,
                                  ),
                                ),
                              )),
                        )
                      : SizedBox()
                ],
              )),
        ),
      );

  Future<void> liked(MapMarker mapMarker) async {
    String userId = FirebaseAuth.instance.currentUser!.uid.toString();
    var collection =
        FirebaseFirestore.instance.collection('locations').doc(mapMarker.id);
    var docSnapshot = await collection.get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    var mapModel = MapMarker.fromJson(data, mapMarker.id);
    List<dynamic>? newDataUserliked = mapModel.likedUser;
    if (newDataUserliked!.length > 0) {
      if (newDataUserliked.contains(userId)) {
        newDataUserliked.remove(userId);
      } else {
        newDataUserliked.add(userId);
      }
    } else {
      newDataUserliked.add(userId);
    }
    if (!data.values.isEmpty) {
      collection.update({
        'name': mapModel.title,
        'address': mapModel.address,
        'image': mapModel.image,
        'latitude': mapModel.endLat,
        'longitude': mapModel.endLng,
        'userId': mapModel.userId,
        'likedUser': newDataUserliked,
      }).then((value) {
        setState(() {
          refresh();
        });
      }).catchError((error) => print("Failed to update user: $error"));
    }
    ;
  }
}
