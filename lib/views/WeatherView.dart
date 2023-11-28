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

  Future<void> _modalSelectLocationM(BuildContext context) async {
    String newLocation = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecione uma cidade'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButton<String>(
                hint: Text('Escolha uma cidade'),
                items: <String>[
                  'Manaus',
                  'Sao Luis',
                  'Sao Paulo',
                  'Curitiba',
                  'Porto Velho',
                  'Cuzco',
                  'Guajara mirim',
                  'Caracas',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  print('Cidade selecionada: $newValue');
                  Navigator.pop(context, newValue);
                },
              ),
              ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar"),
              ),
            ],
          ),
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
              await _modalSelectLocationM(context);
            },
          ),
        ],
      ),
      body: Center(
        child: _weather != null ? Container(child: WeatherWidget(weather: _weather!)) : CircularProgressIndicator(),
      ),
    );
  }
}
