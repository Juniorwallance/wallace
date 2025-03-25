import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lipalocal/database/database_helper.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lipalocal Artisan Tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LocationTrackerPage(),
    );
  }
}

class LocationTrackerPage extends StatefulWidget {
  const LocationTrackerPage({super.key});

  @override
  State<LocationTrackerPage> createState() => _LocationTrackerPageState();
}

class _LocationTrackerPageState extends State<LocationTrackerPage> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  final Set<Marker> _artisanMarkers = {};
  bool _isLoading = true;
  bool _locationServiceEnabled = false;
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkLocationServices();
  }

  Future<void> _checkLocationServices() async {
    _locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_locationServiceEnabled) {
      _showLocationServiceAlert();
      return;
    }

    await _checkLocationPermission();
    if (_permissionGranted) {
      await _getCurrentLocation();
      await _loadArtisanLocations();
    }
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDeniedAlert();
        return;
      }
    }
    _permissionGranted = true;
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 14),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _loadArtisanLocations() async {
    try {
      final artisans = await DatabaseHelper.getArtisansWithLocations();
      
      // Default marker icon
      final BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueOrange,
      );

      setState(() {
        _artisanMarkers.clear();
        for (var artisan in artisans) {
          _artisanMarkers.add(
            Marker(
              markerId: MarkerId(artisan['id'].toString()),
              position: LatLng(
                artisan['latitude'] as double,
                artisan['longitude'] as double,
              ),
              infoWindow: InfoWindow(
                title: artisan['businessName']?.toString() ?? 'Artisan',
                snippet: artisan['skill']?.toString() ?? 'Handmade crafts',
                onTap: () {
                  // Handle marker tap (e.g., navigate to artisan details)
                },
              ),
              icon: markerIcon,
            ),
          );
        }
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading artisans: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _showLocationServiceAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text('Please enable location services to use this feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Denied'),
        content: const Text('This app needs location permissions to show nearby artisans.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artisan Locations'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _isLoading = true);
              _loadArtisanLocations();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition ?? const LatLng(-1.2921, 36.8219),
                zoom: 14.0,
              ),
              markers: _artisanMarkers,
              myLocationEnabled: _permissionGranted,
              myLocationButtonEnabled: _permissionGranted,
              compassEnabled: true,
              mapToolbarEnabled: true,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        backgroundColor: Colors.green,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}