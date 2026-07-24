import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/entities/weather.dart';

class WeatherRemoteDataSource {
  final http.Client client;
  String get apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  WeatherRemoteDataSource({required this.client});

  Future<Weather> getWeatherForecast(String destination) async {
    final uri = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=\$destination&appid=\$apiKey&units=metric');
    
    final response = await client.get(uri);
    
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      
      return Weather(
        temperature: jsonResponse['main']['temp'].toDouble(),
        condition: jsonResponse['weather'][0]['main'],
        description: jsonResponse['weather'][0]['description'],
        iconCode: jsonResponse['weather'][0]['icon'],
      );
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
