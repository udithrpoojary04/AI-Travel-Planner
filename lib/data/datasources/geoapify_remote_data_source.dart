import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeoapifyPlace {
  final String name;
  final String category;

  GeoapifyPlace({required this.name, required this.category});

  factory GeoapifyPlace.fromJson(Map<String, dynamic> json) {
    return GeoapifyPlace(
      name: json['properties']['name'] ?? 'Unknown',
      category: json['properties']['categories'] != null 
          ? (json['properties']['categories'] as List).first.toString() 
          : 'Unknown',
    );
  }
}

class GeoapifyRemoteDataSource {
  final http.Client client;

  GeoapifyRemoteDataSource({required this.client});

  String get apiKey => dotenv.env['GEOAPIFY_API_KEY'] ?? '';

  Future<String?> _getPlaceId(String city) async {
    final encodedCity = Uri.encodeComponent(city);
    final uri = Uri.parse('https://api.geoapify.com/v1/geocode/search?text=\$encodedCity&format=json&apiKey=\$apiKey');
    try {
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          return data['results'][0]['place_id'];
        }
      }
    } catch (e) {
      // Ignored
    }
    return null;
  }

  Future<List<GeoapifyPlace>> getHotels(String city) async {
    final placeId = await _getPlaceId(city);
    if (placeId == null) return [];

    final uri = Uri.parse('https://api.geoapify.com/v2/places?categories=accommodation.hotel,accommodation.guest_house&filter=place:\$placeId&limit=15&apiKey=\$apiKey');
    try {
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'] != null) {
          return (data['features'] as List)
              .map((json) => GeoapifyPlace.fromJson(json))
              .where((place) => place.name != 'Unknown')
              .toList();
        }
      }
    } catch (e) {
      // Ignored
    }
    return [];
  }

  Future<List<GeoapifyPlace>> getRestaurants(String city) async {
    final placeId = await _getPlaceId(city);
    if (placeId == null) return [];

    final uri = Uri.parse('https://api.geoapify.com/v2/places?categories=catering.restaurant,catering.cafe&filter=place:\$placeId&limit=20&apiKey=\$apiKey');
    try {
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'] != null) {
          return (data['features'] as List)
              .map((json) => GeoapifyPlace.fromJson(json))
              .where((place) => place.name != 'Unknown')
              .toList();
        }
      }
    } catch (e) {
      // Ignored
    }
    return [];
  }
}
