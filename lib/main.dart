import 'package:avaliacao_progmobile/views/Index.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avaliação',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Index(),
      debugShowCheckedModeBanner: false,
    );
  }
}