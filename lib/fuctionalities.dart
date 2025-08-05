import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:developer';

class Drawerfunc extends StatefulWidget {
  final Function(LatLng) onPlaceSelected;

  const Drawerfunc({super.key, required this.onPlaceSelected});

  @override
  State<Drawerfunc> createState() => _DrawerfuncState();
}

class _DrawerfuncState extends State<Drawerfunc> {
  // final List _favoritePlaces = [];
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = _auth.currentUser;

  @override
  void initState() {
    super.initState();
  }

  // _loadFavoritePlaces() async {
  //   // var box = await Hive.openBox('favoritePlaces');
  //   // setState(() {
  //   //   _favoritePlaces = box.get('places', defaultValue: []);
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    final String? uid = user?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Favorite Places'),
        backgroundColor: Colors.white,
      ),
      // body: Center(child: Text('data')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: uid)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No place have been stored yet.'));
          }

          if (snapshot.connectionState == ConnectionState.active) {
            log('meassade....');
            // final a = FirebaseFirestore.instance
            //     .collection('users')
            //     .snapshots();

            return ListView.builder(
              itemCount: snapshot.data!.docs.length, //_favoritePlaces.length
              itemBuilder: (context, index) {
                // var place = ; //_favoritePlaces[index]
                return ListTile(
                  leading:
                      // place['image'] != null
                      //     ? InkWell(
                      //         onTap: () {
                      //           showDialog(
                      //             context: context,
                      //             builder: (context) {
                      //               return AlertDialog(
                      //                 content: Column(
                      //                   spacing: 15,
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   children: [
                      //                     Container(
                      //                       clipBehavior: Clip.antiAlias,
                      //                       decoration: BoxDecoration(
                      //                         borderRadius: BorderRadius.circular(
                      //                           10,
                      //                         ),
                      //                       ),
                      //                       child: Image.memory(
                      //                         fit: BoxFit.cover,
                      //                         place['image'],
                      //                       ),
                      //                     ),
                      //                     Row(
                      //                       children: [
                      //                         Spacer(),
                      //                         TextButton(
                      //                           onPressed: () {
                      //                             Navigator.of(context).pop();
                      //                           },
                      //                           child: Text(
                      //                             'Back',
                      //                             style: TextStyle(fontSize: 21),
                      //                           ),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ],
                      //                 ),
                      //               );
                      //             },
                      //           );
                      //         },
                      //         child: CircleAvatar(
                      //           backgroundImage: MemoryImage(place['image']),
                      //         ),
                      //       )
                      CircleAvatar(
                        child: Text(
                          snapshot.data!.docs[index]
                              .data()['name']
                              .toString()
                              .split('')
                              .first
                              .toUpperCase(),
                        ),
                      ),
                  tileColor: Color(0xFF0000),
                  title: Text(snapshot.data!.docs[index].data()['name']),
                  trailing: Row(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // Navigator.pop(context);
                          final newLocation = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GoogleMapsFlutter(
                                isEditing: true,
                                index: index,
                              ),
                            ),
                          );
                          if (newLocation != null) {
                            final docId = snapshot.data!.docs[index].id;
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(docId)
                                .update({
                                  'name': newLocation['name'],
                                  'latitude': newLocation['latitude'],
                                  'longitude': newLocation['longitude'],
                                });

                            // final _txtcontroller = TextEditingController();
                            // final newName = await showDialog(
                            //   context: context,
                            //   builder: (context) => AlertDialog(
                            //     title: Text('Enter place name'),
                            //     content: TextField(
                            //       decoration: InputDecoration(
                            //         hintText: 'Enter place name',
                            //       ),
                            //       controller: _txtcontroller,
                            //     ),
                            //     actions: [
                            //       TextButton(
                            //         child: Text('Cancel'),
                            //         onPressed: () =>
                            //             Navigator.of(context).pop(),
                            //       ),
                            //       TextButton(
                            //         child: Text('Save'),
                            //         onPressed: () {
                            //           Navigator.of(
                            //             context,
                            //           ).pop(_txtcontroller.text);
                            //         },
                            //       ),
                            //     ],
                            //   ),
                            // );

                            // if (newName != null && newName.isNotEmpty) {
                            //   // await FirebaseFirestore.instance
                            //   //     .collection('users')
                            //   //     .doc(snapshot.data!.docs![index].id)
                            //   //     .update(newName);
                            //   // var box = await Hive.openBox('favoritePlaces');
                            //   // var places = box.get('places', defaultValue: []);
                            //   // places[index] = {
                            //   //   'name': newName,
                            //   //   'latitude': newLocation.latitude,
                            //   //   'longitude': newLocation.longitude,
                            //   // };
                            //   // box.put('places', places);
                            //   // _loadFavoritePlaces();
                            // }
                          }
                        },
                        child: Icon(Icons.edit, color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(snapshot.data!.docs[index].id)
                              .delete();
                          // await ManagePlaces.removeFavoritePlace(index);
                          // var box = await Hive.openBox('favoritePlaces');
                          // var places = box.get('places', defaultValue: []);
                          // places.removeAt(index);
                          // box.put('places', places);
                          // _loadFavoritePlaces();
                        },
                        child: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                  onTap: () {
                    widget.onPlaceSelected(
                      LatLng(
                        snapshot.data!.docs[index].data()['latitude'],
                        snapshot.data!.docs[index].data()['longitude'],
                      ),
                    );
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Following error occured:lkl: ${snapshot.error}'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),

      // body: _favoritePlaces.isEmpty
      //     ? Center(child: Text('No favorite places added yet.'))
      //     : ListView.builder(
      //         itemCount: _favoritePlaces.length,
      //         itemBuilder: (context, index) {
      //           var place = _favoritePlaces[index];
      //           return ListTile(
      //             leading: place['image'] != null
      //                 ? InkWell(
      //                     onTap: () {
      //                       showDialog(
      //                         context: context,
      //                         builder: (context) {
      //                           return AlertDialog(
      //                             content: Column(
      //                               spacing: 15,
      //                               mainAxisSize: MainAxisSize.min,
      //                               children: [
      //                                 Container(
      //                                   clipBehavior: Clip.antiAlias,
      //                                   decoration: BoxDecoration(
      //                                     borderRadius: BorderRadius.circular(
      //                                       10,
      //                                     ),
      //                                   ),
      //                                   child: Image.memory(
      //                                     fit: BoxFit.cover,
      //                                     place['image'],
      //                                   ),
      //                                 ),
      //                                 Row(
      //                                   children: [
      //                                     Spacer(),
      //                                     TextButton(
      //                                       onPressed: () {
      //                                         Navigator.of(context).pop();
      //                                       },
      //                                       child: Text(
      //                                         'Back',
      //                                         style: TextStyle(fontSize: 21),
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ],
      //                             ),
      //                           );
      //                         },
      //                       );
      //                     },
      //                     child: CircleAvatar(
      //                       backgroundImage: MemoryImage(place['image']),
      //                     ),
      //                   )
      //                 : CircleAvatar(
      //                     child: Text(
      //                       place['name']
      //                           .toString()
      //                           .split('')
      //                           .first
      //                           .toUpperCase(),
      //                     ),
      //                   ),
      //             tileColor: Color(0xFF0000),
      //             title: Text(place['name']),
      //             trailing: Row(
      //               spacing: 10,
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 GestureDetector(
      //                   onTap: () async {
      //                     Navigator.pop(context);
      //                     final newLocation = await Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (context) => GoogleMapsFlutter(
      //                           isEditing: true,
      //                           index: index,
      //                         ),
      //                       ),
      //                     );
      //                     if (newLocation != null) {
      //                       final _txtcontroller = TextEditingController();
      //                       final newName = await showDialog(
      //                         context: context,
      //                         builder: (context) => AlertDialog(
      //                           title: Text('Enter place name'),
      //                           content: TextField(
      //                             decoration: InputDecoration(
      //                               hintText: 'Enter place name',
      //                             ),
      //                             controller: _txtcontroller,
      //                           ),
      //                           actions: [
      //                             TextButton(
      //                               child: Text('Cancel'),
      //                               onPressed: () =>
      //                                   Navigator.of(context).pop(),
      //                             ),
      //                             TextButton(
      //                               child: Text('Save'),
      //                               onPressed: () {
      //                                 Navigator.of(
      //                                   context,
      //                                 ).pop(_txtcontroller.text);
      //                               },
      //                             ),
      //                           ],
      //                         ),
      //                       );
      //                       if (newName != null && newName.isNotEmpty) {
      //                         var box = await Hive.openBox('favoritePlaces');
      //                         var places = box.get('places', defaultValue: []);
      //                         places[index] = {
      //                           'name': newName,
      //                           'latitude': newLocation.latitude,
      //                           'longitude': newLocation.longitude,
      //                         };
      //                         box.put('places', places);
      //                         _loadFavoritePlaces();
      //                       }
      //                     }
      //                   },
      //                   child: Icon(Icons.edit, color: Colors.black),
      //                 ),
      //                 GestureDetector(
      //                   onTap: () async {
      //                     await ManagePlaces.removeFavoritePlace(index);
      //                     // var box = await Hive.openBox('favoritePlaces');
      //                     // var places = box.get('places', defaultValue: []);
      //                     // places.removeAt(index);
      //                     // box.put('places', places);
      //                     _loadFavoritePlaces();
      //                   },
      //                   child: Icon(Icons.delete, color: Colors.red),
      //                 ),
      //               ],
      //             ),
      //             onTap: () {
      //               widget.onPlaceSelected(
      //                 LatLng(place['latitude'], place['longitude']),
      //               );
      //               Navigator.pop(context);
      //             },
      //           );
      //         },
      //       ),
    );
  }
}
