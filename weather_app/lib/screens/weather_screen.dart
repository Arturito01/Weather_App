import 'dart:ui';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/weather_model.dart';
import '../providers/weather_provider.dart';

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
  String country = '';
  String state = '';
  String city = '';

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      Provider.of<WeatherProvider>(context, listen: false).weather = weather;
      Provider.of<WeatherProvider>(context, listen: false).cityName = cityName;
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  _reloadData() async {
    String cityName = city;
    try {
      final weather = await _weatherService.getWeather(cityName);
      Provider.of<WeatherProvider>(context, listen: false).weather = weather;
      Provider.of<WeatherProvider>(context, listen: false).cityName = cityName;
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  _selectPlace() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Select place"),
        content: SizedBox(
          height: 150,
          width: 300,
          child: Column(
            children: [
              CSCPicker(
                showStates: true,
                showCities: true,
                flagState: CountryFlag.ENABLE,
                countrySearchPlaceholder: "Country",
                stateSearchPlaceholder: "State",
                citySearchPlaceholder: "City",
                countryDropdownLabel: "Country",
                stateDropdownLabel: "State",
                cityDropdownLabel: "City",

                ///triggers once country selected in dropdown
                onCountryChanged: (value) {
                  setState(() {
                    ///store value in country variable
                    country = value;
                  });
                },

                ///triggers once state selected in dropdown
                onStateChanged: (value) {
                  setState(() {
                    ///store value in state variable
                    if (value == null) return;
                    state = value;
                  });
                },

                ///triggers once city selected in dropdown
                onCityChanged: (value) {
                  setState(() {
                    ///store value in city variable
                    if (value == null) return;
                    city = value;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                await _reloadData();
                Navigator.pop(ctx);
              },
              child: const Text("Okay"))
        ],
      ),
    );
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/weather/sunny.json';

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
    final dateTime = DateFormat('EEEE · dd / MM').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Align(
            alignment: const AlignmentDirectional(3, -0.3),
            child: Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blueAccent),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(-3, -0.3),
            child: Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blueAccent),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0, -1.2),
            child: Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(color: Colors.orange),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
            child: Container(
              decoration: const BoxDecoration(color: Colors.transparent),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 100, bottom: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.white70),
                  TextButton(
                    onPressed: _selectPlace,
                    child: Text(
                      _weather?.cityName.toUpperCase() ?? '',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 32,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
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
                  Text(
                    dateTime.toString(),
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
