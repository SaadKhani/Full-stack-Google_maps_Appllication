import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/changes/firebase_services.dart';
import 'package:google_maps/deep_links_utils.dart';
import 'package:google_maps/fuctionalities.dart';
import 'package:google_maps/locations_utils.dart';
import 'package:google_maps/share_places.dart';
import 'package:google_maps/tile_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';

class GoogleMapsFlutter extends StatefulWidget {
  final bool isEditing;
  final int? index;
  final Map<String, dynamic>? existingPlace;
  // ignore: prefer_const_constructors_in_immutables
  GoogleMapsFlutter({
    super.key,
    this.isEditing = false,
    this.index,
    this.existingPlace,
  });

  @override
  State<GoogleMapsFlutter> createState() => _GoogleMapsFlutterState();
}

class _GoogleMapsFlutterState extends State<GoogleMapsFlutter> {
  bool isTraking = false;
  StreamSubscription<Position>? _positionStream;
  // ignore: non_constant_identifier_names
  String? Link;
  LatLng myCurrentLocation = LatLng(30.3753, 69.3451);
  late GoogleMapController googleMapController;
  Marker marker = Marker(
    markerId: MarkerId('Mrker id'),
    position: LatLng(30.3753, 69.3451),
    draggable: false,
    onDragEnd: (value) {},
    infoWindow: InfoWindow(
      title: "Title of the Marker",
      snippet: "more about marker",
    ),
  );

  void _navigateToPlace(LatLng latLng) {
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    log('buildd');
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: myCurrentLocation,
          zoom: 5,
        ),

        markers: {marker},
        onMapCreated: (GoogleMapController controller) {
          log('inmacreated');
          googleMapController = controller;
        },
        tileOverlays: {
          TileOverlay(
            tileOverlayId: TileOverlayId('custom_tile'),
            tileProvider: CachedTileProvider(),
          ),
        },
        onTap: (LatLng latLng) async {
          // Uint8List? imageBytes;
          double latitude = latLng.latitude;
          double longitude = latLng.longitude;
          final txtcontroller = TextEditingController();

          if (widget.isEditing) {
            // Editing existing place
            final newName = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Enter new place name'),
                content: TextField(
                  decoration: InputDecoration(hintText: 'Enter new place name'),
                  controller: txtcontroller,
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: Text('Save'),
                    onPressed: () {
                      log('svae pressed');
                      Navigator.of(context).pop(txtcontroller.text);
                    },
                  ),
                ],
              ),
            );
            log('new name');
            log(newName);
            if (newName != null && newName.isNotEmpty) {
              // var box = await Hive.openBox('favoritePlaces');
              // var places = box.get('places', defaultValue: []);
              // places[widget.index!] = {
              //   'name': newName,
              //   'latitude': latitude,
              //   'longitude': longitude,
              // };
              // box.put('places', places);

              Navigator.of(context).pop({
                'name': newName,
                'latitude': latitude,
                'longitude': longitude,
              });
            }
          } else {
            // Adding new place
            // Show a dialog to enter a custom name
            final customName = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Enter a name for your place'),
                content: TextField(
                  decoration: InputDecoration(hintText: 'Enter a name'),
                  controller: txtcontroller,
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: Text('Add'),
                    onPressed: () {
                      Navigator.of(context).pop(txtcontroller.text);
                    },
                  ),
                ],
              ),
            );
            log(customName.toString());

            if (customName != null && customName.isNotEmpty) {
              await FirestoreService.addFavoritePlace(
                name: customName,
                latitude: latitude,
                longitude: longitude,
              );

              // Get the current user's UID
              // final User? user = FirebaseAuth.instance.currentUser;
              // final String? uid = user?.uid;

              // if (uid != null) {
              //   // Create a map to store the favorite place
              //   var favoritePlace = {
              //     'name': customName,
              //     'latitude': latitude,
              //     'longitude': longitude,
              //   };

              //   // Add the favorite place to Firebase Firestore
              //   final FirebaseFirestore firestore = FirebaseFirestore.instance;
              //   await firestore.collection('users').doc(uid).set(favoritePlace);
              //   log('added');

              // Navigator.of(context).pop();
              // }
            }
          }
        },
        onLongPress: (latLng) {
          final latitude = latLng.latitude;
          final longitude = latLng.longitude;
          final nameController = TextEditingController();
          // show a dialog or card to enter the name
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Enter Name to creat deep link'),
              content: TextField(
                decoration: InputDecoration(hintText: 'Enter name'),
                controller: nameController,
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text('Generate Deep Link'),
                  onPressed: () {
                    final name =
                        nameController.text; // get the text from the text field
                    final deepLink = DeepLinkUtils.generateDeepLink(
                      name,
                      latitude,
                      longitude,
                    );

                    Link = deepLink;
                    // saving to clip Board
                    Clipboard.setData(ClipboardData(text: deepLink));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Deep link copied to clipboard')),
                    );
                    log(deepLink.toString());
                    // display the deep link or use it as needed
                    // Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },

        // onTap: (LatLng latLng) async {
        //   double latitude = latLng.latitude;
        //   double longitude = latLng.longitude;

        //   final _txtcontroller = TextEditingController();

        // Show a dialog to enter a custom name
        // final customName = await showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text('Enter a name for your place'),
        //     content: TextField(
        //       decoration: InputDecoration(hintText: 'Enter a name'),
        //       controller: _txtcontroller,
        //     ),
        //     actions: [
        //       TextButton(
        //         child: Text('Cancel'),
        //         onPressed: () => Navigator.of(context).pop(),
        //       ),
        //       TextButton(
        //         child: Text('Add'),
        //         onPressed: () {
        //           Navigator.of(context).pop(_txtcontroller.text);
        //         },
        //       ),
        //     ],
        //   ),
        // );

        // if (customName != null && customName.isNotEmpty) {
        //   var box = await Hive.openBox('favoritePlaces');
        //   var favoritePlaces = box.get('places', defaultValue: []);
        //   favoritePlaces.add({
        //     'name': customName,
        //     'latitude': latitude,
        //     'longitude': longitude,
        //   });
        //   box.put('places', favoritePlaces);
        // }
        // Navigator.of(context).pop(latLng);
        //   },
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 15),
            child: FloatingActionButton(
              heroTag: 'uniqueTag1',
              onPressed: () async {
                log('pressed');
                Position position = await LocationsUtils.currentPosition();
                LocationsUtils.navigateToPlace(
                  googleMapController,
                  LatLng(position.latitude, position.longitude),
                );
                // googleMapController.animateCamera(
                //   CameraUpdate.newCameraPosition(
                //     CameraPosition(
                //       zoom: 14,
                //       target: LatLng(position.latitude, position.longitude),
                //     ),
                //   ),
                // );
                // log(position.latitude.toString() + 'latitude');
                // log(position.longitude.toString() + 'longitude');
                // log(marker.position.latitude.toString() + 'laitude');
                // log(marker.position.longitude.toString() + 'longitude');
                marker = Marker(
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue,
                  ),
                  markerId: MarkerId('This is my location..'),
                  position: LatLng(position.latitude, position.longitude),
                  draggable: true,
                );
                // log('after');
                // log(marker.position.latitude.toString() + 'laitude');
                // log(marker.position.longitude.toString() + 'longitude');
                setState(() {});
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.my_location, size: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 15),
            child: FloatingActionButton(
              heroTag: 'uniqueTag2',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        Drawerfunc(onPlaceSelected: _navigateToPlace),
                  ),
                );
              },

              backgroundColor: Colors.white,
              child: Icon(Icons.favorite),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 15),
            child: FloatingActionButton(
              heroTag: 'uniqueTag3',
              onPressed: () async {
                if (Link != null) {
                  // ignore: deprecated_member_use
                  await Share.share(Link!);
                }
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.share),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 15),
            child: FloatingActionButton(
              heroTag: 'uniqueTag4',
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        SharePlacesScreen(onPlaceSelected: _navigateToPlace),
                  ),
                );
              },
              child: Icon(Icons.person_pin_circle_outlined, size: 30),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 15),
              child: FloatingActionButton(
                heroTag: 'uniqueTag5',
                backgroundColor: isTraking ? Colors.blue : Colors.white,
                onPressed: () {
                  setState(() {
                    isTraking = !isTraking;
                  });
                  if (isTraking) {
                    _startTracking();
                  } else {
                    _positionStream?.cancel();
                  }
                },
                child: Icon(Icons.track_changes),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startTracking() async {
    if (await _checkLocationServicesAndPermissions()) {
      _positionStream = Geolocator.getPositionStream().listen((
        Position position,
      ) {
        setState(() {
          marker = Marker(
            markerId: MarkerId('This is my location..'),
            position: LatLng(position.latitude, position.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            draggable: true,
          );
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 30,
              ),
            ),
          );
        });
      });
    }
  }

  Future<bool> _checkLocationServicesAndPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('Location services are disabled.');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    _positionStream?.cancel();

    super.dispose();
  }
}
