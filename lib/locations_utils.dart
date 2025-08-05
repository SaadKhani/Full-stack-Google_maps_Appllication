import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationsUtils {
  static Future<Position> currentPosition() async {
    bool serviceEnable;
    LocationPermission permission;

    // check if the service are enabled
    serviceEnable = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnable) {
      return Future.error('Location services are diabled');
    }

    // checking location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location denied permanenetly');
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  static void navigateToPlace(GoogleMapController controller, LatLng latlng) {
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: latlng, zoom: 14)),
    );
  }
}
