import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart' as csv;

class TemperaturaProvider with ChangeNotifier {
  String? _temperatura;
  String? _data;
  List<TemperatureData> _temperatures = [];
  List<TemperatureAverageData> _temperatureAverages = [];

  String? get temperatura => _temperatura;
  String? get data => _data;
  List<TemperatureData> get temperatures => _temperatures;
  List<TemperatureAverageData> get temperatureAverages => _temperatureAverages;

  TemperaturaProvider() {
    fetchData();
    Timer.periodic(Duration(seconds: 30), (_) {
      fetchData();
    });
  }

  String? get galpaoName => null;

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:5000/api'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;

        if (jsonData.isNotEmpty) {
          final List<TemperatureData> temperatureList = jsonData.map((item) {
            final id = item['id'];
            final timestamp = item['timestamp'];
            final value = item['value'];
            return TemperatureData(id, timestamp, value);
          }).toList();

          _temperatures = temperatureList;

          final temperatureMap = calculateTemperatureAverages(temperatureList);
          final List<TemperatureAverageData> averages = [];

          temperatureMap.forEach((dayOfWeek, temperatures) {
            final averageTemperature =
                temperatures.reduce((a, b) => a + b) / temperatures.length;
            final dayOfWeekString = getDayOfWeekString(dayOfWeek);
            averages.add(TemperatureAverageData(dayOfWeekString, averageTemperature));
          });

          _temperatureAverages = averages;

          final ultimaMedicao = temperatureList.last;
          final temperatura = ultimaMedicao.value;
          final data = ultimaMedicao.timestamp;
          _temperatura = temperatura.toString();
          _data = data.toString();
        } else {
          _temperatura = null;
          _data = null;
          throw Exception('Nenhuma medição encontrada na API.');
        }
      } else {
        _temperatura = null;
        _data = null;
        throw Exception('Falha ao carregar os dados da API. Código de status: ${response.statusCode}');
      }
    } catch (error) {
      _temperatura = null;
      _data = null;
      throw Exception('Falha ao carregar os dados da API: $error');
    }

    notifyListeners();
  }

  Map<int, List<double>> calculateTemperatureAverages(List<TemperatureData> temperatureList) {
    final temperatureMap = <int, List<double>>{};
    for (var item in temperatureList) {
      final date = DateTime.parse(item.timestamp);
      final temperature = item.value;
      final dayOfWeek = date.weekday;

      if (temperatureMap.containsKey(dayOfWeek)) {
        temperatureMap[dayOfWeek]!.add(temperature);
      } else {
        temperatureMap[dayOfWeek] = [temperature];
      }
    }
    return temperatureMap;
  }

  String getDayOfWeekString(int dayOfWeek) {
    final now = DateTime.now();
    final weekday = now.subtract(Duration(days: now.weekday - dayOfWeek));
    final formatter = DateFormat('EEEE', 'pt_BR');
    return formatter.format(weekday);
  }

Future<void> downloadCSV(BuildContext context) async {
  final confirmed = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Confirmação'),
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green),
            SizedBox(width: 8),
            Container(child: Text('Deseja fazer o download?')),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text('Download'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );

  if (confirmed == true) {
    try {
      final csvData = [
        ['ID', 'Timestamp', 'Value'],
        for (final data in _temperatures) [data.id, data.timestamp, data.value],
      ];

      final csvFileContent = csv.ListToCsvConverter().convert(csvData);

      final dateTime = DateTime.now();
      final formattedDateTime = DateFormat('yyyyMMdd_HHmmss').format(dateTime);

      final downloadsDirectory = await getDownloadsDirectory();
      final csvFilePath = '${downloadsDirectory!.path}/temperatura_$formattedDateTime.csv';

      final csvFile = File(csvFilePath);
      await csvFile.writeAsString(csvFileContent);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green ,
          content: Row(
            children: [
              Icon(Icons.check_rounded, color: Colors.white,),
              Text('Download concluído com sucesso!',
              style: TextStyle(
                fontSize: 15
              ),),
            ],
          ),
        ),
      );
    } catch (error) {
      throw Exception('Falha ao criar o arquivo CSV: $error');
    }
  }
}

  void updateGalpaoName(String newName) {}

}

class TemperatureData {
  final int id;
  final String timestamp;
  final double value;

  TemperatureData(this.id, this.timestamp, this.value);
}

class TemperatureAverageData {
  final String dayOfWeek;
  final double temperatureAverage;

  TemperatureAverageData(this.dayOfWeek, this.temperatureAverage);
}
