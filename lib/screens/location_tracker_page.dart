import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lipalocal App', // Added title for better app identification
      theme: ThemeData(
        primarySwatch: Colors.green, // Define a theme for consistency
      ),
      home: LocationTrackerPage(),
    );
  }
}

class LocationTrackerPage extends StatefulWidget {
  const LocationTrackerPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LocationTrackerPage createState() => _LocationTrackerPage();
}

class _LocationTrackerPage extends State<LocationTrackerPage> {
  GoogleMapController? mapController;
  final LatLng _center = const LatLng(-1.2921, 36.8219); // Nairobi, Kenya
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addMarkers(); // Moved marker addition to a separate method for clarity
  }

  void _addMarkers() {
    _markers.add(
      Marker(
        markerId: MarkerId('artisan1'),
        position: LatLng(-1.2921, 36.8219),
        infoWindow: InfoWindow(title: 'Artisan 1', snippet: 'Handmade crafts'),
      ),
    );
    // Additional markers can be added here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lipalocal App'),
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers,
      ),
    );
  }
}
