import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacePrediction {
  final String displayName;
  final double lat;
  final double lon;

  PlacePrediction({
    required this.displayName,
    required this.lat,
    required this.lon,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      displayName: json['display_name'],
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
    );
  }
}

class PlacesRemoteDataSource {
  final http.Client client;

  PlacesRemoteDataSource({required this.client});

  Future<List<PlacePrediction>> getPlacePredictions(String query) async {
    if (query.isEmpty) return [];
    
    final uri = Uri.parse('https://nominatim.openstreetmap.org/search?q=\$query&format=json&limit=5');
    
    try {
      final response = await client.get(
        uri,
        headers: {'User-Agent': 'AITravelPlannerApp/1.0'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PlacePrediction.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
