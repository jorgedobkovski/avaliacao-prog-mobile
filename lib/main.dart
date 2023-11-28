import 'package:avaliacao_progmobile/views/Index.dart';
import 'package:flutter/material.dart';

void main() => runApp(
    MaterialApp(
      title: 'Avaliação',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Index(),
      debugShowCheckedModeBanner: false,
    )
);
