import 'dart:developer';
import 'dart:typed_data';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import "package:http/http.dart" as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class CachedTileProvider extends TileProvider {
  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    if (zoom == null) {
      return Tile(x, y, Uint8List.fromList([]));
    }
    var box = Hive.box('mapTiles');
    String key = '$zoom-$x-$y';

    try {
      // Check for internet connectivity
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        // If offline, return cached tile if available
        if (box.containsKey(key)) {
          log('Returning cached tile: $key');
          return Tile(x, y, box.get(key));
        } else {
          // If no cached tile, return an empty tile
          log('No cached tile available: $key');
          return Tile(x, y, Uint8List.fromList([]));
        }
      } else {
        // If online, try to download tile and cache it
        if (box.containsKey(key)) {
          log('Tile loaded from cache: $key');
          return Tile(x, y, box.get(key));
        } else {
          // Download tile and cache it
          String url =
              'https://mts.googleapis.com/vt?lyrs=m&x=$x&y=$y&z=$zoom&key=AIzaSyCqw5ul9JggZ3YremcVWNSpWaqgxTpccVI';
          var response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            box.put(key, response.bodyBytes);
            log('Tile downloaded and cached: $key');
            return Tile(x, y, response.bodyBytes);
          } else {
            log('Failed to download tile: $key');
            return Tile(x, y, Uint8List.fromList([]));
          }
        }
      }
    } catch (e) {
      log('Error loading tile: $e');
      return Tile(x, y, Uint8List.fromList([]));
    }
  }
}

// class CachedTileProvider extends TileProvider {
//   @override
//   Future<Tile> getTile(int x, int y, int? zoom) async {
//     if (zoom == null) {
//       return Tile(x, y, Uint8List(0));
//     }

//     var box = Hive.box('mapTiles');
//     String key = '$zoom-$x-$y';
//     if (box.containsKey(key)) {
//       log('Tile loaded from cache: $key');
//       return Tile(x, y, box.get(key));
//     } else {
//       // Download tile and cache it
//       log('Downloading tile: $key');
//       String url =
//           'https://mts.googleapis.com/vt?lyrs=m&x=$x&y=$y&z=$zoom&key=AIzaSyCqw5ul9JggZ3YremcVWNSpWaqgxTpccVI';
//       var response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         box.put(key, response.bodyBytes);
//         log("Tile downloaded and cahached: $key");
//         return Tile(x, y, response.bodyBytes);
//       } else {
//         log('Failed to download Tile: $key');
//         return Tile(x, y, Uint8List(0));
//       }
//     }
//   }
// }
