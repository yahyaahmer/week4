import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiKey = "73d6196aae367440a1035e5322b4b1a8";
const String apiUrl =
    "https://api.openweathermap.org/data/2.5/weather?lat=25.1932024&lon=67.1554619&appid=$apiKey&units=metric";

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
    );
  }
}

class Weather {
  final String city;
  final double temp, high, low;
  final String description;

  Weather({
    required this.city,
    required this.temp,
    required this.high,
    required this.low,
    required this.description,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    city: json["name"],
    temp: json["main"]["temp"].toDouble(),
    high: json["main"]["temp_max"].toDouble(),
    low: json["main"]["temp_min"].toDouble(),
    description: json["weather"][0]["description"],
  );
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Weather? weather;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      setState(() => weather = Weather.fromJson(json.decode(response.body)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather")),
      body: Center(
        child:
            weather == null
                ? const CircularProgressIndicator()
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weather!.city,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${weather!.temp}°C",
                      style: const TextStyle(fontSize: 32),
                    ),
                    Text("High: ${weather!.high}°C / Low: ${weather!.low}°C"),
                    Text(
                      weather!.description,
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
