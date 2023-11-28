import 'dart:convert';
import 'package:avaliacao_progmobile/views/widgets/WeatherWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  String _selectedLocation = 'Porto Velho';
  Map<String, dynamic>? _weather;

  Future<void> _getWeatherData(String location) async {
    final apiKey = '97886118f4931c3424b870899c0abf18';
    final apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      setState(() {
        _weather = json.decode(response.body);
      });
    } else {
      setState(() {
        _weather = null;
      });
    }
  }

  Future<void> _modalSelectLocation(BuildContext context) async {
    String newLocation = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('Manaus'),
              onTap: () {
                Navigator.pop(context, 'Manaus');
              },
            ),
            ListTile(
              title: Text('Sao Luis'),
              onTap: () {
                Navigator.pop(context, 'Sao Luis');
              },
            ),
            ListTile(
              title: Text('Sao Paulo'),
              onTap: () {
                Navigator.pop(context, 'Sao Paulo');
              },
            ),
            ListTile(
              title: Text('Curitiba'),
              onTap: () {
                Navigator.pop(context, 'Curitiba');
              },
            ),
            ListTile(
              title: Text('Porto Velho'),
              onTap: () {
                Navigator.pop(context, 'Porto Velho');
              },
            ),
            ListTile(
              title: Text('Cuzco'),
              onTap: () {
                Navigator.pop(context, 'Cuzco');
              },
            ),
            ListTile(
              title: Text('Guajará-Mirim'),
              onTap: () {
                Navigator.pop(context, 'Guajara mirim');
              },
            ),
            ListTile(
              title: Text('Caracas'),
              onTap: () {
                Navigator.pop(context, 'Caracas');
              },
            ),
            // Add more locations as needed
          ],
        );
      },
    );

    if (newLocation != null && newLocation != _selectedLocation) {
      setState(() {
        _selectedLocation = newLocation;
      });
      await _getWeatherData(_selectedLocation);
    }
  }

  @override
  void initState() {
    super.initState();
    _getWeatherData(_selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Climática'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              await _modalSelectLocation(context);
            },
          ),
        ],
      ),
      body: Center(
        child: _weather != null
            ? Container(
                child: WeatherWidget(weather: _weather!),
            )
            : CircularProgressIndicator(),
      ),
    );
  }
}
