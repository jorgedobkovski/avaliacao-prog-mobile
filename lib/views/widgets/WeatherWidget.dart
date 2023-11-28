import 'package:flutter/material.dart';

class WeatherWidget extends StatelessWidget {
  final Map<String, dynamic> weather;

  const WeatherWidget({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final local = weather['name'];
    final temperatura = (weather['main']['temp']-273.15);
    final clima = weather['weather'][0]['description'];


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.radar, size: 70),
        Text(
          '$local',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Temperatura: ${temperatura.toStringAsFixed(2)}°C',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        Text(
          'Clima: $clima',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
