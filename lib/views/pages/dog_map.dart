import 'dart:async';
import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet/scoped_model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DogMap extends StatefulWidget {
  @override
  _DogMapPageState createState() => _DogMapPageState();
}

class _DogMapPageState extends State<DogMap> {
  // Collar _counter = Collar();
  DatabaseReference _petRef;
  StreamSubscription<Event> _petSubscription;
  final Completer<GoogleMapController> _controller = Completer();
  final FirebaseDatabase database = FirebaseDatabase();
  // ignore: unused_field
  DatabaseError _error;
  // Dio dio = Dio();

  Set<Marker> _markers = HashSet<Marker>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getCollarLocation();
  }

  @override
  void dispose() {
    super.dispose();
    _petSubscription.cancel();
  }

  _getCollarLocation() async {
    await _fetchdata();
    await _setMarkers();
    await _goToCollar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PETS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'K2D',
          ),
        ),
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.yellowAccent[700],
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) =>
            _controller.complete(controller),
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        markers: _markers,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.yellowAccent[700],
        onPressed: _getCollarLocation,
        label: Text('Locate Dog!'),
        icon: Icon(Icons.pin_drop),
      ),
    );
  }

  Future<void> _goToCollar() async {
    final user = ScopedModel.of<UserModel>(context, rebuildOnChange: false);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(user.lat ?? 0, user.lng ?? 0),
          zoom: 10,
        ),
      ),
    );
  }

  Future<void> _fetchdata() async {
    final user = ScopedModel.of<UserModel>(context, rebuildOnChange: false);
    _petRef = database.reference().child('Pet');
    _petRef.keepSynced(true);
    _petSubscription = _petRef.onValue.listen((Event event) {
      user.updateLat(event.snapshot.value['Latitude'] ?? 0.0);
      user.updateLng(event.snapshot.value['Longitude'] ?? 0.0);
    }, onError: (Object o) {
      final DatabaseError error = o;
      setState(() {
        _error = error;
      });
    });
  }

  Future<void> _setMarkers() async {
    final user = ScopedModel.of<UserModel>(context, rebuildOnChange: false);
    final String markerIdVal = 'marker_id_1';
    _markers.clear();
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(markerIdVal),
          position: LatLng(user.lat ?? 0, user.lng ?? 0),
          onTap: () => _launchURL(user.lat ?? 0, user.lng ?? 0),
        ),
      );
    });
  }

  void _launchURL(num lat, num lng) async =>
      await canLaunch('https://www.google.com/maps/@$lat,$lng,15z')
          ? await launch('https://www.google.com/maps/@$lat,$lng,15z')
          : throw 'Could not launch';
}
