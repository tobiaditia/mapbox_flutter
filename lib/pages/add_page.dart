import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_flutter/settings/application_settings.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  CollectionReference locations =
      FirebaseFirestore.instance.collection('locations');

  File? file;
  ImagePicker image = ImagePicker();
  String url = "";
  var name;
  bool isLoading = false;
  late final LatLng myLocation;

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: (FirebaseAuth.instance.currentUser != null)
                ? ((!isLoading)
                    ? Column(
                        children: [
                          Text(
                            'Lokasi Wisata',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color(0xff504F5E)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            elevation: 2,
                            onPressed: () {
                              getImage();
                            },
                            child: Text(
                              "Ambil Gambar",
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white),
                            ),
                            color: Colors.black.withOpacity(.6),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(label: Text('Nama')),
                          ),
                          TextField(
                            controller: addressController,
                            decoration: InputDecoration(label: Text('Address')),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            height: 250,
                            child: FutureBuilder(
                                future: getLocation(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: Text('LOADING MAP ....'),
                                    );
                                  }
                                  print(myLocation);
                                  return FlutterMap(
                                    options: MapOptions(
                                        minZoom: 5, zoom: 13, center: myLocation),
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
                                              return Center(
                                                child: AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 400),
                                                  child: const Icon(
                                                    Icons.location_on,
                                                    size: 50,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              );
                                            })
                                      ]),
                                    ],
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton.icon(
                            onPressed: addLocation,
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                primary: Colors.black.withOpacity(.6),
                                elevation: 2),
                            icon: Icon(Icons.add_circle),
                            label: const Text('Tambahkan'),
                          )
                        ],
                      )
                    : Stack(
                        alignment: FractionalOffset.center,
                        children: <Widget>[
                          new CircularProgressIndicator(
                            backgroundColor: Colors.red,
                          ),
                        ],
                      ))
                : Center(
                    child: Text('Harus Login Dahulu !'),
                  ),
          ),
        ),
      ),
    );
  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.camera);

    if (img?.path != null) {
      name = img!.name;
      file = File(img.path);
      setState(() {});
    } else {
      setState(() {});
    }
  }

  Future uploadFile() async {
    try {
      var imagefile =
          FirebaseStorage.instance.ref().child("locations").child("/$name");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();

      if (url != '' && file != null) {
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(showAlert(false, 'Error !'));
      }
    } on Exception catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(showAlert(false, 'error !'));
    }
  }

  addLocation() async {
    setState(() {
      isLoading = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    if (nameController.text == null || nameController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(showAlert(false, 'Nama tidak boleh kosong !'));
      setState(() {
        isLoading = false;
      });
      return Future.error(1);
    }
    if (addressController.text == null || addressController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(showAlert(false, 'Address tidak boleh kosong !'));
      setState(() {
        isLoading = false;
      });
      return Future.error(1);
    }
    if (file == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(showAlert(false, 'Gambar tidak boleh kosong !'));
      setState(() {
        isLoading = false;
      });
      return Future.error(1);
    }

    await uploadFile();

    return locations.add({
      'name': nameController.text,
      'address': addressController.text,
      'image': url,
      'likedUser': [],
      'latitude': myLocation.latitude.toString() == ''
          ? '-8.084429972199272'
          : myLocation.latitude.toString(),
      'longitude': myLocation.longitude.toString() == ''
          ? '112.17616549859079'
          : myLocation.longitude.toString(),
      'userId': FirebaseAuth.instance.currentUser!.uid.toString(),
    }).then((value) {
      print("Locations Added");

      nameController.clear();
      addressController.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(showAlert(true, 'Berhasil menambahkan Data !'));
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(showAlert(false, 'Error di Server !'));
    });
  }

  SnackBar showAlert(bool success, String text) {
    return SnackBar(
      backgroundColor: success ? Colors.green : Colors.red,
      duration: Duration(seconds: 1),
      content: Text(text),
    );
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

  Future getLocation() async {
    await _determinePosition();
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true);
      myLocation = LatLng(position.latitude, position.longitude);
    } catch (e) {
      print(e);
    }
  }
}
