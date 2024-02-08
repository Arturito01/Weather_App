import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherProvider extends ChangeNotifier {
  Weather? _weather;
  String? _cityName;

  Weather? get weather => _weather;
  String? get cityName => _cityName;

  set weather(Weather? value) {
    _weather = value;
    notifyListeners();
  }

  set cityName(String? name) {
    _cityName = name;
    notifyListeners();
  }
}