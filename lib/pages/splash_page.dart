import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_flutter/pages/main_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MainPage())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2C96F1),
      body: Container(
        padding: EdgeInsets.all(35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 130,
              height: 150,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black, offset: Offset.fromDirection(2)),
                  ],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image:
                          AssetImage("assets/animated_markers_map/map4.jpg"))),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                'Penentuan Jalur Tercepat Wisata Kota Blitar',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 24),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
