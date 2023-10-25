import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'temperatura_provider.dart';

class TemperatureListPage extends StatefulWidget {
  @override
  _TemperatureListPageState createState() => _TemperatureListPageState();
}

class _TemperatureListPageState extends State<TemperatureListPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchDate = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Temperaturas'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Pesquisar por data',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchDate = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchDate = _searchController.text;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchDate = '';
                    });
                  },
                ),
              ],
            ),
          ),
          Consumer<TemperaturaProvider>(
            builder: (context, provider, _) {
              final filteredTemperatures = provider.temperatures.where(
                (temperature) {
                  final dateTime = DateTime.parse(temperature.timestamp);
                  final formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                  return formattedDate.contains(_searchDate);
                },
              ).toList();

              if (filteredTemperatures.isNotEmpty) {
                return Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: filteredTemperatures.length,
                    itemBuilder: (context, index) {
                      final temperature = filteredTemperatures[index];
                      final dateTime = DateTime.parse(temperature.timestamp);
                      final formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                      final formattedTime =
                          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.date_range),
                                  SizedBox(width: 4),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.access_time),
                                  SizedBox(width: 4),
                                  Text(
                                    formattedTime,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.thermostat),
                                  SizedBox(width: 4),
                                  Text(
                                    '${temperature.value}°C',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: Text('Nenhuma temperatura encontrada.'),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}