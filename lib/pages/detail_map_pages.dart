import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_flutter/animated_markers_map/map_marker.dart';
import 'package:mapbox_flutter/widgets/map_widgets.dart';

class DetailMap extends StatefulWidget {
  const DetailMap({Key? key}) : super(key: key);

  @override
  State<DetailMap> createState() => _DetailMapState();
}

class _DetailMapState extends State<DetailMap>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Blitar Location'),
        actions: [
          IconButton(
              onPressed: () => null, icon: Icon(Icons.filter_alt_outlined))
        ],
      ),
      body: Stack(
        children: [
          MapWidget(
              startLng: '112.16489361584573',
              startLat: '-8.113147856552782',
              endLng: '112.1840767738206',
              endLat: '-8.098532470089827'),
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: 20,
          //   height: MediaQuery.of(context).size.height * .3,
          //   child: PageView.builder(
          //     controller: _pageController,
          //     itemBuilder: (context, index) {
          //       final item = mapMarkers[index];
          //       return _MapItemDetails(
          //         mapMarker: item,
          //       );
          //     },
          //     itemCount: mapMarkers.length,
          //   ),
          // )
        ],
      ),
    );
  }
}

// class _MapItemDetails extends StatelessWidget {
//   const _MapItemDetails({Key? key, required this.mapMarker}) : super(key: key);
//   final MapMarker mapMarker;

//   @override
//   Widget build(BuildContext context) {
//     final _styleTitle = TextStyle(
//         color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
//     final _styleAddress = TextStyle(color: Colors.grey[800], fontSize: 14);
//     return Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: Card(
//         margin: EdgeInsets.zero,
//         color: Colors.white,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//                   Expanded(child: Image.asset(mapMarker.image)),
//                   SizedBox(
//                     width: 15,
//                   ),
//                   Expanded(
//                       child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         mapMarker.title,
//                         style: _styleTitle,
//                         textAlign: TextAlign.center,
//                       ),
//                       Text(
//                         mapMarker.address,
//                         style: _styleAddress,
//                       ),
//                     ],
//                   ))
//                 ],
//               ),
//             ),
//             MaterialButton(
//               onPressed: () => {},
//               color: MAPBOX_COLOR,
//               padding: EdgeInsets.zero,
//               elevation: 6,
//               child: Text(
//                 'Go',
//                 style:
//                     TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }