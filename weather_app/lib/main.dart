import 'package:flutter/material.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/screens/weather_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: const MaterialApp(
        title: 'Weather App',
        home: WeatherScreen(),
      ),
    );
  }
}