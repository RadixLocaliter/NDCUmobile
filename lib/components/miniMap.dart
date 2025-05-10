import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

class MiniMap extends StatefulWidget {
  final void Function(dynamic) onLocationChange;
  const MiniMap({Key? key, required this.onLocationChange}) : super(key: key);
  @override
  _MiniMapState createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> {
  late GoogleMapController _controller;

  final LatLng _center = const LatLng(45.521563, -122.677433);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    widget.onLocationChange({"lat": _center.latitude, "lng": _center.longitude});
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    final serviceStatus = await perm.Permission.locationWhenInUse.serviceStatus;
    bool isGpsOn = serviceStatus == perm.ServiceStatus.enabled;

    if (!isGpsOn) {
      print('Turn on location services before requesting permission.');
      return;
    }

    final status = await perm.Permission.locationWhenInUse.request();
    if (status == perm.PermissionStatus.granted) {
      print('Permission granted');
    } else if (status == perm.PermissionStatus.denied) {
      print(
          'Permission denied. Show a dialog and again ask for the permission');
    } else if (status == perm.PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    widget.onLocationChange({"lat": position.latitude, "lng": position.longitude});
    final marker = Marker(
      markerId: MarkerId('place_name'),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(
        title: 'title',
        snippet: 'address',
      ),
    );
    setState(() {
      markers[MarkerId('MyLocation')] = marker;
    });
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 20.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: markers.values.toSet(),
      ),
    );
  }
}
