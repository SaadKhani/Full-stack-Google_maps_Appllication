import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps/changes/place_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final User? user = _auth.currentUser;
  static final String? uid = user?.uid;

  static Future<void> addFavoritePlace({
    required String name,
    required double latitude,
    required double longitude,
  }) async {
    if (uid != null) {
      try {
        await _firestore.collection('users').doc(name).set({
          "id": uid,
          'name': name,
          'latitude': latitude,
          'longitude': longitude,
        });
      } catch (e) {
        print('Error adding favorite place: $e');
      }
    } else {
      print('User is not signed in');
    }
  }

  static Future<List<Place>> getPlaces(String name) async {
    final querySnapshot = await _firestore
        .collection(name)
        .where('id', isEqualTo: uid)
        .get();
    final places = querySnapshot.docs
        .map((doc) => Place.fromJson(doc.data()))
        .toList();

    return places;
  }
}
