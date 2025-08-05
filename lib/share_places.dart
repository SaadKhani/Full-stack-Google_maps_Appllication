import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

class SharePlacesScreen extends StatefulWidget {
  final Function(LatLng)? onPlaceSelected;
  final String? placeName;
  final double? latitude;
  final double? longitude;

  const SharePlacesScreen({
    super.key,
    this.placeName,
    this.latitude,
    this.longitude,
    this.onPlaceSelected,
  });

  @override
  State<SharePlacesScreen> createState() => _SharePlacesScreenState();
}

class _SharePlacesScreenState extends State<SharePlacesScreen> {
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   var box = Hive.box('sharePlaces');
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shared Places')),
      body: Column(
        children: [
          // Recent shared place
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: RecentSharedPlace(
              onPlaceSelected: widget.onPlaceSelected,
              placeName: widget.placeName,
              latitude: widget.latitude,
              longitude: widget.longitude,
            ),
          ),
          SizedBox(height: 20),

          Divider(indent: 40),
          // All shared places
          Expanded(
            child: AllSharedPlaces(onPlaceSelected: widget.onPlaceSelected),
          ),
        ],
      ),
    );
  }
}

class RecentSharedPlace extends StatelessWidget {
  final String? placeName;
  final double? latitude;
  final double? longitude;
  final Function(LatLng)? onPlaceSelected;

  RecentSharedPlace({
    this.placeName,
    this.latitude,
    this.longitude,
    required this.onPlaceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return latitude == null || longitude == null
        ? Card(child: ListTile(title: Text('No place is shared')))
        : Card(
            child: ListTile(
              onTap: () {
                if (onPlaceSelected != null) {
                  onPlaceSelected!(LatLng(latitude!, longitude!));
                }

                Navigator.pop(context);
              },
              title: Text(placeName ?? 'Unknown Place'),
              subtitle: Text('Latitude: $latitude, Longitude: $longitude'),
            ),
          );
  }
}

class AllSharedPlaces extends StatefulWidget {
  final Function(LatLng)? onPlaceSelected;
  AllSharedPlaces({required this.onPlaceSelected});
  @override
  _AllSharedPlacesState createState() => _AllSharedPlacesState();
}

class _AllSharedPlacesState extends State<AllSharedPlaces> {
  var box = Hive.box('sharePlaces');

  @override
  Widget build(BuildContext context) {
    return box.length == 0
        ? Center(child: Text('No shared places'))
        : ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final place = box.getAt(index);
              return ListTile(
                onTap: () {
                  if (widget.onPlaceSelected != null) {
                    widget.onPlaceSelected!(
                      LatLng(place['latitude'], place['longitude']),
                    );
                    Navigator.of(context).pop();
                  }
                },
                title: Text(place['name'] ?? 'Unknown Place'),
                subtitle: Text(
                  'Latitude: ${place['latitude']}, Longitude: ${place['longitude']}',
                ),
              );
            },
          );
  }
}
