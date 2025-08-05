class Place {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  Place({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
