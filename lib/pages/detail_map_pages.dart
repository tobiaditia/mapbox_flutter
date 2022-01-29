import 'package:flutter/material.dart';
import 'package:mapbox_flutter/models/map_marker.dart';
import 'package:mapbox_flutter/widgets/map_widgets.dart';

class DetailMapPage extends StatefulWidget {
  final MapMarker mapMarker;
  const DetailMapPage({Key? key, required this.mapMarker}) : super(key: key);

  @override
  State<DetailMapPage> createState() => _DetailMapPageState();
}

class _DetailMapPageState extends State<DetailMapPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mapMarker.title),
      ),
      body: MapWidget(
        mapMarker: widget.mapMarker,
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