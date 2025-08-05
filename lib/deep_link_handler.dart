import 'package:flutter/material.dart';
import 'package:google_maps/share_places.dart';
import 'package:hive/hive.dart';

class DeepLinkHandler {
  static void handleDeepLink(BuildContext context, Uri deepLink) {
    final latitude = double.parse(deepLink.queryParameters['lat']!);
    final longitude = double.parse(deepLink.queryParameters['lng']!);
    final placeName = deepLink.queryParameters['name'];

    var box = Hive.box('sharePlaces');
    box.add({'name': placeName, 'latitude': latitude, 'longitude': longitude});

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SharePlacesScreen(
          placeName: placeName,
          latitude: latitude,
          longitude: longitude,
        ),
      ),
    );
  }
}
