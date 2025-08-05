import 'package:hive/hive.dart';

class ManagePlaces {
  static Future<void> addFavoritePlace(
    double latitude,
    double longitude,
    String name,
  ) async {
    var box = await Hive.openBox('favoritePlaces');
    var favoritePlaces = box.get('places', defaultValue: []);
    favoritePlaces.add({
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    });
    box.put('places', favoritePlaces);
  }

  static Future<void> removeFavoritePlace(int index) async {
    var box = await Hive.openBox('favoritePlaces');
    var places = box.get('places', defaultValue: []);
    places.removeAt(index);
    box.put('places', places);
  }

  static Future<List> getFavoritePlaces() async {
    var box = await Hive.openBox('favoritePlaces');
    return box.get('places', defaultValue: []);
  }
}
