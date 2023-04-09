import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class CommutePage extends StatefulWidget {
  const CommutePage({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<CommutePage> {
  Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  // Work
  static const LatLng _work = LatLng(43.6481932, -79.3790628);
  static final CameraPosition _camWork = CameraPosition(
    target: _work,
    zoom: 16,
  );

  // Home
  static const LatLng _home = LatLng(43.734664846231205, -79.37423021927064);
  static final CameraPosition _camHome = CameraPosition(
    target: _home,
    zoom: 16,
  );

  LatLng _currentLocation =
      const LatLng(43.6572, -79.3787); // Set default location to (0, 0)
  LatLng _lastMapPosition =
      const LatLng(43.6572, -79.3787); //Set defaul location to (0,0)

  // Code added
  // Adding mapType
  MapType _currentMapType = MapType.normal;
  // Marker
  final Set<Marker> _markers = {};

  // Tracking current location

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    // Add the new marker to the _markers set
    final Marker _workMarker = Marker(
      markerId: MarkerId('work'),
      position: _work,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(title: 'First Canadian Place'),
    );
    _markers.add(_workMarker);
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _lastMapPosition = LatLng(position.latitude, position.longitude);
    });
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
              target: _currentLocation,
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

  bool _isWorkSnackBarVisible = false;

  Future<void> _gotowork() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_camWork));

    final distance = await Geolocator.distanceBetween(
      _currentLocation.latitude,
      _currentLocation.longitude,
      _work.latitude,
      _work.longitude,
    );
    final timeInMinutes = (distance / 1000 * 60 / 50).ceil();

    final timeString = _formatTime(timeInMinutes);

    if (!_isWorkSnackBarVisible) {
      final snackBar = SnackBar(
        content: Row(
          children: [
            Expanded(
              child: Icon(
                Icons.directions_car,
                color: Colors.white,
                size: 32,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Text(
                'Time to work: $timeString',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        duration: Duration(seconds: 5),
        onVisible: () => _isWorkSnackBarVisible = true,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        _isWorkSnackBarVisible = false;
      });
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }

    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId('Work'),
        position: _work,
        onTap: () {
          setState(() {
            _markers.removeWhere(
              (marker) => marker.markerId.value == 'work',
            );
            _isWorkSnackBarVisible = false;
          });
          _gotowork();
        },
        infoWindow: const InfoWindow(
          title: 'Work',
        ),
      ));
    });
  }

  String _formatTime(int timeInMinutes) {
    if (timeInMinutes < 60) {
      return '$timeInMinutes min';
    } else if (timeInMinutes < 1440) {
      final hours = timeInMinutes ~/ 60;
      final minutes = timeInMinutes % 60;
      return '$hours h ${minutes} min';
    } else {
      final days = timeInMinutes ~/ 1440;
      final hours = (timeInMinutes % 1440) ~/ 60;
      return '$days d $hours h';
    }
  }

  bool _isHomeSnackBarVisible = false;

  Future<void> _gotoPlace() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_camHome));

    final distance = await Geolocator.distanceBetween(
      _currentLocation.latitude,
      _currentLocation.longitude,
      _home.latitude,
      _home.longitude,
    );
    final timeInMinutes = (distance / 1000 * 60 / 50).ceil();

    final timeString = _formatTime(timeInMinutes);

    if (!_isHomeSnackBarVisible) {
      final snackBar = SnackBar(
        content: Row(
          children: [
            Expanded(
              child: Icon(
                Icons.directions_car,
                color: Colors.white,
                size: 32,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Text(
                'Time to Home: $timeString',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        duration: Duration(seconds: 5),
        onVisible: () => _isHomeSnackBarVisible = true,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        _isHomeSnackBarVisible = false;
      });
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }

    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId('Home'),
        position: _home,
        onTap: () {
          setState(() {
            _markers.removeWhere(
              (marker) => marker.markerId.value == 'home',
            );
            _isHomeSnackBarVisible = false;
          });
          _gotoPlace();
        },
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
