import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WeatherScreenState();
  }
}

class _WeatherScreenState extends State<WeatherScreen> {
  // api key
  final _weatherService = WeatherService('f34fde1ba54b0e115314bec0331166d3');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatehrAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/weather/sunny.json'; // default

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/weather/cloud.json';
      case 'fog':
        return 'assets/weather/cloud.json';
      case 'thunderstorm':
        return 'assets/weather/storm.json';
      case 'shower rain':
        return 'assets/weather/rainy.json';
      case 'clear':
        return 'assets/weather/sunny.json';
      default:
        return 'assets/weather/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, bottom: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _weather?.cityName.toUpperCase() ?? '',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 24,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Lottie.asset(getWeatehrAnimation(_weather?.mainCondition)),
              const Spacer(),
              Text(
                '${_weather?.temperature.round()}ºC',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 24,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                _weather?.mainCondition ?? '',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 24,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
