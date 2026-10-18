import 'dart:convert';
import 'package:http/http.dart' as http;

class WikipediaRemoteDataSource {
  final http.Client client;

  WikipediaRemoteDataSource({required this.client});

  Future<String> getCityExtract(String city) async {
    final encodedCity = Uri.encodeComponent(city);
    final uri = Uri.parse('https://en.wikipedia.org/w/api.php?action=query&prop=extracts&explaintext&titles=\$encodedCity&format=json');
    try {
      final response = await client.get(
        uri,
        headers: {'User-Agent': 'AITravelPlanner/1.0'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pages = data['query']['pages'] as Map<String, dynamic>;
        
        for (var key in pages.keys) {
          if (key == '-1') return '';
          return pages[key]['extract'] ?? '';
        }
      }
    } catch (e) {
      // Ignored
    }
    return '';
  }
}
