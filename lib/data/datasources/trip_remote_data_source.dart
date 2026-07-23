import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/trip.dart';
import '../models/trip_model.dart';

abstract class TripRemoteDataSource {
  Future<TripModel> generateItinerary(Trip tripPreferences);
}

class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  final http.Client client;
  final String grokApiKey = 'xai-pU21d6VfOqZqW0H2jZ0Fh8Gk1k5x1iFhYgW9ZfW2T0pW6I0QyR7OqN5H7'; // Provided by user / standard for testing or inject it via env. Actually, Grok API base URL is https://api.x.ai/v1/chat/completions

  TripRemoteDataSourceImpl({required this.client});

  @override
  Future<TripModel> generateItinerary(Trip trip) async {
    final days = trip.endDate.difference(trip.startDate).inDays + 1;
    final prompt = '''
You are an expert AI Travel Planner. Generate a detailed $days-day itinerary for a trip to ${trip.destination}.
Start Date: ${trip.startDate.toIso8601String().split('T')[0]}
End Date: ${trip.endDate.toIso8601String().split('T')[0]}
Budget: \$${trip.budget}
Interests: ${trip.interests.join(', ')}

Please output the itinerary strictly in the following JSON format without any markdown or extra text. Ensure the JSON is perfectly valid.
{
  "itinerary": [
    {
      "dayNumber": 1,
      "date": "YYYY-MM-DD",
      "activities": [
        {
          "time": "09:00 AM",
          "title": "Activity Title",
          "description": "Activity Description",
          "location": "Activity Location",
          "costEstimate": 50.0
        }
      ]
    }
  ]
}
''';

    final response = await client.post(
      Uri.parse('https://api.x.ai/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer \$grokApiKey',
      },
      body: json.encode({
        'model': 'grok-beta',
        'messages': [
          {'role': 'system', 'content': 'You are a JSON-only API. Only output valid JSON.'},
          {'role': 'user', 'content': prompt}
        ],
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final String content = jsonResponse['choices'][0]['message']['content'];
      
      // Clean up markdown block if present
      String cleanJson = content.trim();
      if (cleanJson.startsWith('```json')) {
        cleanJson = cleanJson.substring(7);
      }
      if (cleanJson.endsWith('```')) {
        cleanJson = cleanJson.substring(0, cleanJson.length - 3);
      }
      
      final parsedJson = json.decode(cleanJson);
      
      final itineraryList = (parsedJson['itinerary'] as List)
          .map((e) => ItineraryDayModel.fromJson(e))
          .toList();
          
      return TripModel(
        id: trip.id,
        destination: trip.destination,
        startDate: trip.startDate,
        endDate: trip.endDate,
        budget: trip.budget,
        interests: trip.interests,
        itineraryModel: itineraryList,
      );
    } else {
      throw Exception('Failed to generate itinerary: \${response.body}');
    }
  }
}
