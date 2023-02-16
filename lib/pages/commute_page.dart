// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CommutePage extends StatefulWidget {
  const CommutePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<CommutePage> {
  Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  // Work
  static LatLng _work = const LatLng(43.6577, -79.3788);
  static final CameraPosition _camWork = CameraPosition(
    target: _work,
    zoom: 16,
  );

  // Home
  static LatLng _home = const LatLng(43.734664846231205, -79.37423021927064);
  static final CameraPosition _camHome = CameraPosition(
    target: _home,
    zoom: 16,
  );

  static const LatLng _center = LatLng(43.734664846231205, -79.37423021927064);
  // Code added
  // Adding mapType
  MapType _currentMapType = MapType.normal;
  // Marker
  final Set<Marker> _markers = {};

  // Tracking current location
  LatLng _lastMapPosition = _center;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commute',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.blueGrey.shade500,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            polylines: Set<Polyline>.of(polylines.values),
            onMapCreated: _onMapCreated,
            mapType: _currentMapType, // Map type
            markers: _markers, // markers
            onCameraMove: _onCameraMove, // Moves camera
            myLocationEnabled: true, // shows user location
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            // ignore: prefer_const_constructors
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: FloatingActionButton(
                      heroTag: "btn1",
                      onPressed: _onMapTypeButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.cyan,
                      child: const Icon(Icons.map, size: 24.0),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: FloatingActionButton(
                      heroTag: "btn2",
                      onPressed: _onAddMarkerButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.cyan,
                      child: const Icon(Icons.add_location, size: 24.0),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: FloatingActionButton(
                      heroTag: "btn3",
                      onPressed: _gotowork,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.work, size: 24.0),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: FloatingActionButton(
                      heroTag: "btn4",
                      onPressed: _gotoPlace,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.home, size: 24.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Future<void> _gotowork() async {
    //Fly camera there
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_camWork));

    // Mark it
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: const MarkerId('work'),
        position: _work,
        infoWindow: const InfoWindow(
          title: 'Work',
        ),
      ));
    });
  }

  Future<void> _gotoPlace() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_camHome));

    // Mark it
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: const MarkerId('home'),
        position: _home,
        infoWindow: const InfoWindow(
          title: 'Home',
        ),
      ));
    });
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: const MarkerId('destination'),
        position: _lastMapPosition,
        infoWindow: const InfoWindow(
          title: 'Destination',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }
}
