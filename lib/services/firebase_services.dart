import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseServices {
  Future<QuerySnapshot<Object?>> getDataFromFireStore() async {
    CollectionReference locations =
        FirebaseFirestore.instance.collection('locations');
    return locations.get();
  }

  Future<List> getDataFromFireStoreToList() async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("locations");

    //get image url from firebase storage
    // var url = await ref.getDownloadURL();
    List data = [];
    FirebaseFirestore.instance
        .collection("locations")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        data.add(result.data());
      });
        print(data);
    });
    return [];
  }

  Future<String> getImageFromFireStorage(String name) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("locations")
        .child(name);

    return await ref.getDownloadURL();
  }
}
