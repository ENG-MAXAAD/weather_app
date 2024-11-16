import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey =
      '56158752a5d44eae82b65618241611'; // Replace with your WeatherAPI key
  final String baseUrl = 'http://api.weatherapi.com/v1';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = '$baseUrl/current.json?key=$apiKey&q=$city';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print('response: ${response.body}');
      return jsonDecode(response.body);
    } else {
      print('Error: ${response.body}');
      throw Exception('Failed to load weather');
    }
  }
}
