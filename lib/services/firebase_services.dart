import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:latlong2/latlong.dart';
import 'package:mapbox_flutter/models/map_marker.dart';

class FirebaseServices {
  Future<QuerySnapshot<Object?>> getDataFromFireStore() async {
    CollectionReference locations =
        FirebaseFirestore.instance.collection('locations');
    return locations.get();
  }

  Future<List<MapMarker>> getDataFromFireStoreToList(
      {String query = '', bool favourite = false}) async {
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child("locations");

    List<MapMarker> data = [];
    List<MapMarker> data2 = [];
    return FirebaseFirestore.instance
        .collection("locations")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        data.add(MapMarker(
            id: result.id,
            image: result.get('image'),
            title: result.get('name'),
            address: result.get('address'),
            location: LatLng(double.parse(result.get('latitude')),
                double.parse(result.get('longitude'))),
            endLat: result.get('latitude'),
            endLng: result.get('longitude'),
            userId: result.get('userId'),
            likedUser: result.get('likedUser')));
      });
      if (!favourite) {
        data2 = data
            .where((location) {
              final titleLower = location.title.toLowerCase();
              final searchLower = query.toLowerCase();

              return titleLower.contains(searchLower);
            })
            .where((location) => location.userId == '')
            .toList();
      } else {
        data2 = data
            .where((location) {
              final titleLower = location.title.toLowerCase();
              final searchLower = query.toLowerCase();

              return titleLower.contains(searchLower);
            })
            .where((location) =>
                location.likedUser!.contains(
                    FirebaseAuth.instance.currentUser!.uid.toString()) ||
                location.userId ==
                    FirebaseAuth.instance.currentUser!.uid.toString())
            .toList();
      }
      return data2;
    });
  }

  // Future<List> getDataFromFireStoreToList(String query) async {
  //   firebase_storage.Reference ref =
  //       firebase_storage.FirebaseStorage.instance.ref().child("locations");

  //   List data = [];
  //   FirebaseFirestore.instance
  //       .collection("locations")
  //       .get()
  //       .then((querySnapshot) {
  //     querySnapshot.docs.forEach((result) {
  //       data.add(result.data());
  //     });
  //     print(data);
  //   });
  //   return [];
  // }

  Future<String> getImageFromFireStorage(String name) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("locations")
        .child(name);

    return await ref.getDownloadURL();
  }
}

class TempModel {}
