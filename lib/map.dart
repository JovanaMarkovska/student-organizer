import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:student_organizer/application_bloc.dart';
import 'package:student_organizer/place.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _mapController = Completer();
  StreamSubscription? locationSubscription;
  StreamSubscription? boundsSubscription; 
  final _locationController = TextEditingController();

  @override
  void initState() {
    final applicationBloc =
    Provider.of<ApplicationBloc>(context, listen: false);


    //Listen for selected Location
    locationSubscription = applicationBloc.selectedLocation.stream.listen((place) {
      if (place != null) {
        _locationController.text = place.name!;
        //_goToPlace(place);
      } else
        _locationController.text = "";
    });

    applicationBloc.bounds!.stream.listen((bounds) async {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    });
    super.initState();
  }



  @override
  void dispose() {
    final applicationBloc =
    Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.dispose();
    _locationController.dispose();
    locationSubscription!.cancel();
    boundsSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Map'),
          actions: [
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
        resizeToAvoidBottomInset : false,
        body: (applicationBloc.currentLocation == null)
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView(
          children: [
            Stack(
              children: [
                Container(
                  height: 610.0,
                  child: GoogleMap(
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                      new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
                    ].toSet(),
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          applicationBloc.currentLocation!.latitude,
                          applicationBloc.currentLocation!.longitude),
                      zoom: 14,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController.complete(controller);
                    },
                    markers: Set<Marker>.of(applicationBloc.markers),
                  ),
                ),



              ],
            ),


          ],
        ));

  }

  // Future<void> _goToPlace(Place place) async {
  //   final GoogleMapController controller = await _mapController.future;
  //   controller.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //           target: LatLng(
  //               place.geometry.location.lat, place.geometry.location.lng),
  //           zoom: 14.0),
  //     ),
  //   );
  // }
}