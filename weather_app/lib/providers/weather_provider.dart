import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherProvider extends ChangeNotifier {
  Weather? _weather;

  Weather? get weather => _weather;

  set weather(Weather? value) {
    _weather = value;
    notifyListeners();
  }
}