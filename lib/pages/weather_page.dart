import 'dart:math';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:weather/weather.dart';

WeatherFactory wf = WeatherFactory("618774ba56bdfedf15cce5001b815715");

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.grey,
      ),
      body: const WeatherStates(),
    );
  }
}

class WeatherStates extends StatefulWidget {
  const WeatherStates({super.key});

  @override
  State<WeatherStates> createState() => _TempState();
}

class _TempState extends State<WeatherStates> {
  double? _feelsLike = 0;
  double? _minTemp = 0;
  double? _maxTemp = 0;
  double? _currTemp = 0;

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  void getWeather() async {
    Weather w = await wf.currentWeatherByCityName("Toronto");
    if (mounted) {
      setState(() {
        _feelsLike = w.tempFeelsLike?.celsius;
        _feelsLike = roundDouble(_feelsLike!, 2);

        _minTemp = w.tempMin?.celsius;
        _minTemp = roundDouble(_minTemp!, 2);

        _maxTemp = w.tempMax?.celsius;
        _maxTemp = roundDouble(_maxTemp!, 2);

        _currTemp = w.temperature?.celsius;
        _currTemp = roundDouble(_currTemp!, 2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getWeather();
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      fixedSize: const Size(350, 100),
    );

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            style: style,
            onPressed: () {},
            child: Text("Current: $_currTemp °C"),
          ),
          const SizedBox(height: 70),
          ElevatedButton(
            style: style,
            onPressed: () {},
            child: Text("Feels Like: $_feelsLike °C"),
          ),
          const SizedBox(height: 70),
          ElevatedButton(
            style: style,
            onPressed: () {},
            child: Text("Min: $_minTemp °C"),
          ),
          const SizedBox(height: 70),
          ElevatedButton(
            style: style,
            onPressed: () {},
            child: Text("Max: $_maxTemp °C"),
          ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }
}
