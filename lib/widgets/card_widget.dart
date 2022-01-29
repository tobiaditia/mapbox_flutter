import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_flutter/models/map_marker.dart';

class CardWidget extends StatefulWidget {
  const CardWidget(
      {Key? key,
      required this.mapMarker,
      required this.image,
      required this.title})
      : super(key: key);
  final String image;
  final String title;
  final MapMarker mapMarker;

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: 150,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(widget.image, fit: BoxFit.cover),
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
                    Text(widget.title,
                        style: TextStyle(color: Colors.white, fontSize: 18))
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
                              liked();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 1),
                                content:
                                    Text('Berhasil Menambahkan ke favorit'),
                              ));
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                                border: Border.all(
                                    color: Colors.grey.shade500, width: 1)),
                            child: Icon(
                              Icons.favorite,
                              color: (widget.mapMarker.likedUser!.contains(
                                      FirebaseAuth.instance.currentUser!.uid
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
        ));
  }

  Future<void> liked() async {
    String userId = FirebaseAuth.instance.currentUser!.uid.toString();
    var collection = FirebaseFirestore.instance
        .collection('locations')
        .doc(widget.mapMarker.id);
    var docSnapshot = await collection.get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    var mapModel = MapMarker.fromJson(data, widget.mapMarker.id);
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
        setState(() {});
      }).catchError((error) => print("Failed to update user: $error"));
    }
    ;
  }
}
