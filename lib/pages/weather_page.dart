import 'dart:math';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';

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
        backgroundColor: Colors.blueGrey.shade500,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bkg4.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: const WeatherStates(),
      ),
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
  double? _rain = 0;
  double? _wind = 0;
  String description = " ";
  TextStyle style2 = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  Future<void> getWeather() async {
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

        description = w.weatherDescription!;
        _rain = w.rainLast3Hours ?? 0;
        _wind = w.windSpeed ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            WeatherIcons.day_cloudy,
            color: Colors.white,
            size: 80,
          ),
          const Padding(padding: EdgeInsetsDirectional.all(5)),
          const Text(
            'Toronto',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const Padding(padding: EdgeInsetsDirectional.all(30)),
          const Text(
            'Currently',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const Padding(padding: EdgeInsetsDirectional.all(5)),
          Text(
            '$_currTemp °C',
            style: const TextStyle(
              fontSize: 55,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const Padding(padding: EdgeInsetsDirectional.all(5)),
          Text(
            description,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const Padding(padding: EdgeInsets.all(60)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  Text('$_feelsLike°',
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      )),
                  const Text('Feels like',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      )),
                ],
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  Text('$_minTemp°',
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      )),
                  const Text('Min',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      )),
                ],
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  Text('$_maxTemp°',
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      )),
                  const Text('Max',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      )),
                ],
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.all(40)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                WeatherIcons.cloudy_gusts,
                color: Colors.white,
                size: 30,
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Text(
                '$_wind m/s',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const Padding(padding: EdgeInsets.all(20)),
              const Icon(
                WeatherIcons.raindrop,
                color: Colors.white,
                size: 30,
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Text(
                '$_rain mm',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
