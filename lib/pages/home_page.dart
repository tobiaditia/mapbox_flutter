import 'package:animated_type_ahead_searchbar/animated_type_ahead_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_flutter/models/map_marker.dart';
import 'package:mapbox_flutter/pages/detail_map_pages.dart';
import 'package:mapbox_flutter/widgets/card_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text('Search'),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: mapMarkers.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DetailMapPage(
                                    mapMarker: mapMarkers[index])));
                          },
                          child: CardWidget(
                              image: mapMarkers[index].image,
                              title: mapMarkers[index].title),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
