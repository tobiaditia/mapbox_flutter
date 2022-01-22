import 'package:flutter/material.dart';
import 'package:mapbox_flutter/animated_markers_map/animated_markers_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: AnimatedMarkersMap()
    );
  }
}
