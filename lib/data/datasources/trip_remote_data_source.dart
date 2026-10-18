import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/entities/trip.dart';
import '../models/trip_model.dart';
import 'geoapify_remote_data_source.dart';
import 'wikipedia_remote_data_source.dart';

abstract class TripRemoteDataSource {
  Future<TripModel> generateItinerary(Trip tripPreferences);
}

class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  final http.Client client;
  final GeoapifyRemoteDataSource geoapifySource;
  final WikipediaRemoteDataSource wikiSource;
  String get grokApiKey => dotenv.env['GROK_API_KEY'] ?? '';

  TripRemoteDataSourceImpl({
    required this.client, 
    required this.geoapifySource,
    required this.wikiSource,
  });

  @override
  Future<TripModel> generateItinerary(Trip trip) async {
    // RAG step: Fetch real places
    final hotelsList = await geoapifySource.getHotels(trip.destination);
    final restaurantsList = await geoapifySource.getRestaurants(trip.destination);
    
    // Fetch Wikipedia Context
    final wikiContext = await wikiSource.getCityExtract(trip.destination);

    final hotelNames = hotelsList.map((e) => e.name).take(15).join(', ');
    final restaurantNames = restaurantsList.map((e) => e.name).take(15).join(', ');

    final days = trip.endDate.difference(trip.startDate).inDays + 1;
    final prompt = '''
You are an expert AI Travel Planner. Generate a detailed $days-day itinerary for a trip to ${trip.destination}.
Start Date: ${trip.startDate.toIso8601String().split('T')[0]}
End Date: ${trip.endDate.toIso8601String().split('T')[0]}
Budget: ₹${trip.budget} (INR)
Interests: ${trip.interests.join(', ')}

IMPORTANT: I have retrieved a list of 100% REAL, verified places in ${trip.destination} directly from the Geoapify API. 
You MUST strictly use these exact places in your itinerary when scheduling meals and stays:
- Real Hotels: ${hotelNames.isNotEmpty ? hotelNames : 'No verified hotels found.'}
- Real Restaurants: ${restaurantNames.isNotEmpty ? restaurantNames : 'No verified restaurants found.'}

I have also retrieved the official Wikipedia summary for ${trip.destination}. Use this to extract REAL, historic attractions and monuments for the itinerary:
--- WIKIPEDIA EXTRACT ---
${wikiContext.isNotEmpty ? (wikiContext.length > 5000 ? wikiContext.substring(0, 5000) : wikiContext) : 'No Wikipedia context available. Rely strictly on your internal knowledge for attractions.'}
-------------------------

CRITICAL RULES:
1. DO NOT invent, hallucinate, or guess names (e.g. do not invent "Hotel Mahalakshmi" or "Nandini Deluxe").
2. DO NOT use generic placeholders like "Local Restaurant", "Explore local attractions", or "Farewell Dinner".
3. If the provided list of restaurants/hotels is small, YOU MUST REUSE THEM across multiple days, or specify "Meals at Hotel" rather than inventing new places or using generic names.
4. For attractions, you MUST extract real monuments, temples, or parks from the Wikipedia text. 
5. If you use your internal knowledge to add famous attractions, they MUST be located geographically WITHIN ${trip.destination}. DO NOT include places from neighboring towns or cities (e.g. if the destination is Karkala, do NOT include places from Moodbidri).

Also, ALL Dinner activities MUST be scheduled at or after 07:30 PM.

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
  ],
  "packingList": [
    "Item 1",
    "Item 2"
  ]
}
''';

    final response = await client.post(
      Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $grokApiKey',
      },
      body: json.encode({
        'model': 'llama-3.3-70b-versatile',
        'response_format': {'type': 'json_object'},
        'messages': [
          {'role': 'system', 'content': 'You are a strict JSON-only API for a luxury travel planner. You MUST ONLY recommend real, verified, physically existing places. Use exact Google Maps names. Do NOT hallucinate.'},
          {'role': 'user', 'content': prompt}
        ],
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final String content = jsonResponse['choices'][0]['message']['content'];
      
      String cleanJson = content.trim();
      if (cleanJson.startsWith('```json')) cleanJson = cleanJson.substring(7);
      if (cleanJson.endsWith('```')) cleanJson = cleanJson.substring(0, cleanJson.length - 3);
      
      final parsedJson = json.decode(cleanJson);
      
      final itineraryList = (parsedJson['itinerary'] as List)
          .map((e) => ItineraryDayModel.fromJson(e))
          .toList();
          
      final packingList = List<String>.from(parsedJson['packingList'] ?? []);
          
      return TripModel(
        id: trip.id,
        destination: trip.destination,
        startDate: trip.startDate,
        endDate: trip.endDate,
        budget: trip.budget,
        interests: trip.interests,
        itineraryModel: itineraryList,
        packingList: packingList,
      );
    } else {
      throw Exception('Failed to generate itinerary: ${response.body}');
    }
  }
}
