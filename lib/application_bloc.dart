import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:student_organizer/geometry.dart';
import 'package:student_organizer/location.dart';
import 'package:student_organizer/place.dart';
import 'package:student_organizer/geolocator_service.dart';
import 'package:student_organizer/marker_service.dart';
import 'package:student_organizer/places_service.dart';

class ApplicationBloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();
  final markerService = MarkerService();

  //Variables
  Position? currentLocation;
  // ignore: close_sinks
  StreamController<Place?> selectedLocation = StreamController<Place>();
  StreamController<LatLngBounds>? bounds = StreamController<LatLngBounds>();
  Place? selectedLocationStatic;
  String? placeType;
  List<Place>? placeResults;
  List<Marker> markers=List.empty();
  List<Marker> nearestMarker=List.empty();



  ApplicationBloc() {
    setCurrentLocation();

  }


  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    selectedLocationStatic = Place(name: null,
        geometry: Geometry(location: Location(
            lat: currentLocation!.latitude, lng: currentLocation!.longitude),), vicinity: null, realName: '');
    notifyListeners();
  }



  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation.add(sLocation);
    selectedLocationStatic = sLocation;
    notifyListeners();
  }

  clearSelectedLocation() {
    selectedLocation.add(null);
    selectedLocationStatic = null;
    placeType = null;
    notifyListeners();
  }

  togglePlaceType(String value, bool selected) async {
    if (selected) {
      placeType = value;
    } else {
      placeType = null;
    }

    if (placeType != null) {
      var places = await placesService.getPlaces(
          selectedLocationStatic!.geometry.location.lat,
          selectedLocationStatic!.geometry.location.lng, placeType!);
      markers= [];
      nearestMarker=[];

      // final coordinates = new Coordinates(selectedLocationStatic!.geometry.location.lat,selectedLocationStatic!.geometry.location.lng);
      // var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      // String city = address.first.locality;

      if (places.length > 0) {
        markers.clear();
        for(int i=0;i<places.length ;i++){
          var everyMarker = markerService.createMarkerFromEveryPlace(places[i],false);
          markers.add(everyMarker!);
        }
        var newMarker = markerService.createMarkerFromPlace(places[0],false);
        markers.add(newMarker!);
        nearestMarker.add(newMarker);

      }

      var locationMarker = markerService.createMarkerFromPlace(selectedLocationStatic!,true);
      markers.add(locationMarker!);
      nearestMarker.add(locationMarker);


      var _bounds = markerService.bounds(Set<Marker>.of(nearestMarker));
      bounds!.add(_bounds!);

      notifyListeners();
    }
  }

  @override
  void dispose() {
    selectedLocation.close();
    bounds!.close();
    super.dispose();
  }

}