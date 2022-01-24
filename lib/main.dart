import 'package:flutter/material.dart';
import 'package:mapbox_flutter/pages/detail_map_pages.dart';
import 'package:mapbox_flutter/pages/home_page.dart';
import 'package:mapbox_flutter/pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MainPage()
    );
  }
}
