import 'package:flutter/material.dart';
import 'package:weatherapp/service/weather_service.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/widget/weather_info_card.dart';
import '../components/widget/weather_info_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService weatherService = WeatherService();
  final TextEditingController cityController = TextEditingController();

  bool isLoading = false;
  Map<String, dynamic>? weatherData;
  String? errorMessage;

  void fetchWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await weatherService.fetchWeather(cityController.text);
      setState(() {
        weatherData = data;
        isLoading = false;
      });
      cityController.clear(); // Clear the text field after successful fetch
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'City not found. Please try again.';
      });
    }
  }

  LinearGradient getBackgroundGradient(String? condition) {
    if (condition == null) return _defaultGradient;

    condition = condition.toLowerCase();
    if (condition.contains('sunny') || condition.contains('clear')) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
      );
    } else if (condition.contains('rain') || condition.contains('drizzle')) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF4682B4), Color(0xFF000080)],
      );
    } else if (condition.contains('cloud')) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFA9A9A9), Color(0xFF708090)],
      );
    } else if (condition.contains('snow')) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE0FFFF), Color(0xFFB0E0E6)],
      );
    } else {
      return _defaultGradient;
    }
  }

  LinearGradient get _defaultGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFA07A), Color(0xFF800080)],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: getBackgroundGradient(
              weatherData?['current']['condition']['text']),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Weather Forecast',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter city name',
                    prefixIcon: Icon(Icons.search, color: Color(0xFFFFA07A)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                // SizedBox(height: 10),
                // ElevatedButton(
                //   onPressed: fetchWeather,
                //   child: Text('Get Weather'),
                //   style: ElevatedButton.styleFrom(
                //     foregroundColor: Color(0xFF800080),
                //     backgroundColor: Colors.white,
                //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //   ),
                // ),
                SizedBox(height: 30),
                if (isLoading)
                  Center(child: CircularProgressIndicator(color: Colors.white))
                else if (errorMessage != null)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 60, color: Colors.white),
                        SizedBox(height: 20),
                        Text(
                          errorMessage!,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else if (weatherData != null)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            weatherData!['location']['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            weatherData!['location']['country'],
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${weatherData!['current']['temp_c']}°C',
                                    style: GoogleFonts.poppins(
                                      fontSize: 64,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    weatherData!['current']['condition']
                                        ['text'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Image.network(
                                'https:${weatherData!['current']['condition']['icon']}',
                                width: 100,
                                height: 100,
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          WeatherInfoCard(
                            title: 'Details',
                            items: [
                              WeatherInfoItem(
                                icon: Icons.thermostat,
                                title: 'Feels like',
                                value:
                                    '${weatherData!['current']['feelslike_c']}°C',
                              ),
                              WeatherInfoItem(
                                icon: Icons.water_drop,
                                title: 'Humidity',
                                value:
                                    '${weatherData!['current']['humidity']}%',
                              ),
                              WeatherInfoItem(
                                icon: Icons.air,
                                title: 'Wind',
                                value:
                                    '${weatherData!['current']['wind_kph']} km/h',
                              ),
                              WeatherInfoItem(
                                icon: Icons.visibility,
                                title: 'Visibility',
                                value:
                                    '${weatherData!['current']['vis_km']} km',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: fetchWeather,
        child: Icon(
          Icons.arrow_circle_right,
          size: 50,
        ),
      ),
    );
  }
}
