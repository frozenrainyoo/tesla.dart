// To parse this JSON data, do
//
//     final nearbyLocations = nearbyLocationsFromJson(jsonString);

import 'dart:convert';

import 'package:http/http.dart' as http;

NearbyLocations nearbyLocationsFromJson(String str) {
  final _response = json.decode(str);
  return NearbyLocations.fromJson(_response['response']);
}

String nearbyLocationsToJson(NearbyLocations data) =>
    json.encode(data.toJson());

Future<NearbyLocations> nearbyLocationsFromNetwork(
    String token, String id) async {
  final url =
      'https://owner-api.teslamotors.com/api/1/vehicles/$id/nearby_charging_sites';
  final response = await http.get(
    url,
    headers: {
      'User-Agent': "sidecar-tesla",
      'Authorization': 'Bearer $token',
    },
  );
  return nearbyLocationsFromJson(response.body);
}

class NearbyLocations {
  int congestionSyncTimeUtcSecs;
  List<DestinationCharging> destinationCharging;
  List<Supercharger> superchargers;
  int timestamp;

  NearbyLocations({
    this.congestionSyncTimeUtcSecs,
    this.destinationCharging,
    this.superchargers,
    this.timestamp,
  });

  NearbyLocations copyWith({
    int congestionSyncTimeUtcSecs,
    List<DestinationCharging> destinationCharging,
    List<Supercharger> superchargers,
    int timestamp,
  }) =>
      NearbyLocations(
        congestionSyncTimeUtcSecs:
            congestionSyncTimeUtcSecs ?? this.congestionSyncTimeUtcSecs,
        destinationCharging: destinationCharging ?? this.destinationCharging,
        superchargers: superchargers ?? this.superchargers,
        timestamp: timestamp ?? this.timestamp,
      );

  factory NearbyLocations.fromJson(Map<String, dynamic> json) =>
      NearbyLocations(
        congestionSyncTimeUtcSecs: json["congestion_sync_time_utc_secs"],
        destinationCharging: List<DestinationCharging>.from(
            json["destination_charging"]
                .map((x) => DestinationCharging.fromJson(x))),
        superchargers: List<Supercharger>.from(
            json["superchargers"].map((x) => Supercharger.fromJson(x))),
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "congestion_sync_time_utc_secs": congestionSyncTimeUtcSecs,
        "destination_charging":
            List<dynamic>.from(destinationCharging.map((x) => x.toJson())),
        "superchargers":
            List<dynamic>.from(superchargers.map((x) => x.toJson())),
        "timestamp": timestamp,
      };
}

class DestinationCharging {
  Location location;
  String name;
  String type;
  double distanceMiles;

  DestinationCharging({
    this.location,
    this.name,
    this.type,
    this.distanceMiles,
  });

  DestinationCharging copyWith({
    Location location,
    String name,
    String type,
    double distanceMiles,
  }) =>
      DestinationCharging(
        location: location ?? this.location,
        name: name ?? this.name,
        type: type ?? this.type,
        distanceMiles: distanceMiles ?? this.distanceMiles,
      );

  factory DestinationCharging.fromJson(Map<String, dynamic> json) =>
      DestinationCharging(
        location: Location.fromJson(json["location"]),
        name: json["name"],
        type: json["type"],
        distanceMiles: json["distance_miles"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "name": name,
        "type": type,
        "distance_miles": distanceMiles,
      };
}

class Location {
  double lat;
  double long;

  Location({
    this.lat,
    this.long,
  });

  Location copyWith({
    double lat,
    double long,
  }) =>
      Location(
        lat: lat ?? this.lat,
        long: long ?? this.long,
      );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        long: json["long"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "long": long,
      };
}

class Supercharger {
  Location location;
  String name;
  String type;
  double distanceMiles;
  int availableStalls;
  int totalStalls;
  bool siteClosed;

  Supercharger({
    this.location,
    this.name,
    this.type,
    this.distanceMiles,
    this.availableStalls,
    this.totalStalls,
    this.siteClosed,
  });

  Supercharger copyWith({
    Location location,
    String name,
    String type,
    double distanceMiles,
    int availableStalls,
    int totalStalls,
    bool siteClosed,
  }) =>
      Supercharger(
        location: location ?? this.location,
        name: name ?? this.name,
        type: type ?? this.type,
        distanceMiles: distanceMiles ?? this.distanceMiles,
        availableStalls: availableStalls ?? this.availableStalls,
        totalStalls: totalStalls ?? this.totalStalls,
        siteClosed: siteClosed ?? this.siteClosed,
      );

  factory Supercharger.fromJson(Map<String, dynamic> json) => Supercharger(
        location: Location.fromJson(json["location"]),
        name: json["name"],
        type: json["type"],
        distanceMiles: json["distance_miles"].toDouble(),
        availableStalls: json["available_stalls"],
        totalStalls: json["total_stalls"],
        siteClosed: json["site_closed"],
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "name": name,
        "type": type,
        "distance_miles": distanceMiles,
        "available_stalls": availableStalls,
        "total_stalls": totalStalls,
        "site_closed": siteClosed,
      };
}

