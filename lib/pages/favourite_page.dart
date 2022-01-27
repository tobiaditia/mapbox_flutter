import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class FovouritePage extends StatefulWidget {
  const FovouritePage({Key? key}) : super(key: key);

  @override
  _FovouritePageState createState() => _FovouritePageState();
}

class _FovouritePageState extends State<FovouritePage> {
  Position? _currentPosition;

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
    }

    return  Scaffold(
      body: (FirebaseAuth.instance.currentUser != null) ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentPosition != null)
              Text(
                  "LAT: ${_currentPosition!.latitude}, LNG: ${_currentPosition!.longitude}"),
            FlatButton(
              child: Text("Get location"),
              onPressed: () {
                print('hello');
                _getCurrentLocation();
              },
            ),
          ],
        ),
      ) : Center(child: Text('Login dahulu')),
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


  _getCurrentLocation() {
    _determinePosition();
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }
}
