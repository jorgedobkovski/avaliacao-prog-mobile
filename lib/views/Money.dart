import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoneyView extends StatefulWidget {
  const MoneyView({super.key});

  @override
  State<MoneyView> createState() => _MoneyViewState();
}

class _MoneyViewState extends State<MoneyView> {
  final List<String> _currencies = ['USD', 'EUR', 'BRL', 'JPY', 'CAD'];
  String _selectedCurrency = 'BRL';
  Map<String, dynamic>? _exchangeRates;
  double _amount = 0.0;

  Future<void> _updateExchangeRates() async {
    final url = 'https://open.er-api.com/v6/latest/$_selectedCurrency';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        _exchangeRates = json.decode(response.body)['rates'];
      });
    } else {
      setState(() {
        _exchangeRates = null;
      });
    }
  }

  Widget _buildConversionList() {
    if (_exchangeRates == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: _currencies.length,
          itemBuilder: (BuildContext context, int index) {
            final currency = _currencies[index];
            final exchangeRate = _exchangeRates![currency];
            final convertedAmount = _amount * exchangeRate;
            return ListTile(
              title: Text(
                '$currency: ${convertedAmount.toStringAsFixed(2)}',
              ),
            );
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _updateExchangeRates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambio de moedas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Digite um valor:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _amount = double.tryParse(value) ?? 0.0;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite o valor',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Selecione a moeda base:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedCurrency,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCurrency = newValue!;
                  _updateExchangeRates();
                });
              },
              items:
                  _currencies.map<DropdownMenuItem<String>>((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            _buildConversionList(),
          ],
        ),
      ),
    );
  }
}
