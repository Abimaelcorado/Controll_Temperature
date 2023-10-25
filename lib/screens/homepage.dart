import 'package:app_temperatura/screens/listar_temperaturas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'temperatura_provider.dart';

class HomePage extends StatelessWidget {

  final String galpaoName;

  const HomePage({Key? key, required this.galpaoName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(galpaoName),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "/settings");
          },
          icon: Icon(Icons.settings),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<TemperaturaProvider>(
              builder: (context, provider, _){
                if (provider.temperatura != null){
                  final percentual = double.parse(provider.temperatura!) / 100.0;
                  final temperatura = double.parse(provider.temperatura!);
                  // Verificar temperatura alta
                  if (temperatura >= 28) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        barrierDismissible: false, // Impede que o usuário feche o alerta tocando fora dele
                        builder: (context) {
                          Future.delayed(Duration(seconds: 5), () {
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop(); // Fecha o alerta após 10 segundos
                            }
                          });

                          return AlertDialog(
                            title: Text('Temperatura Alta'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('A temperatura está acima de 30 graus!'),
                                SizedBox(height: 16),
                                SpinKitWave(
                                  color: Theme.of(context).primaryColor,
                                  size: 30.0,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    });
                  }
                  if (temperatura <= 18) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        barrierDismissible: false, // Impede que o usuário feche o alerta tocando fora dele
                        builder: (context) {
                          Future.delayed(Duration(seconds: 5), () {
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop(); // Fecha o alerta após 10 segundos
                            }
                          });

                          return AlertDialog(
                            title: Text('Temperatura Baixa'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('A temperatura etá abaixo de 22 graus!'),
                                SizedBox(height: 16),
                                SpinKitWave(
                                  color: Theme.of(context).primaryColor,
                                  size: 30.0,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    });
                  }
                  return  Expanded(
                    child: Column(
                      children: [
                        Center(child: Text("Gráfico de temperatura",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),)),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircularPercentIndicator(
                              radius: 120,
                              lineWidth: 11,
                              percent: percentual,
                              progressColor: Colors.blue,
                              circularStrokeCap: CircularStrokeCap.round,
                              backgroundColor: const Color.fromARGB(255, 230, 230, 230),
                              center: Center(
                                child: Text(
                                  "${provider.temperatura}°",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(padding: EdgeInsets.only(left: 8)),
                                    Icon(Icons.date_range_outlined,),
                                    Padding(padding: EdgeInsets.only(left: 4)),
                                    Text(
                                      "${provider.data}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Padding(padding: EdgeInsets.only(left: 8)),
                                    Icon(Icons.thermostat),
                                    Padding(padding: EdgeInsets.only(left: 4)),
                                    Text(
                                      "${provider.temperatura}°C",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () => provider.downloadCSV(context),
                              child: Text("Download CSV"),
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(Size(40, 40))
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TemperatureListPage()),
                                );
                              },
                              child: Text("Listar temperaturas"),
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(Size(40, 40))
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 50,),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 230, 230, 230),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30, right: 50, bottom: 50, top: 50),
                              child: BarChart(
                                BarChartData(
                                  barGroups: provider.temperatureAverages.asMap().entries.map((entry) {
                                    final index = entry.key + 1;
                                    final data = entry.value;
                                                        
                                    return BarChartGroupData(
                                      x: index,
                                      barRods: [
                                        BarChartRodData(
                                          y: data.temperatureAverage,
                                          colors: [Colors.blue],
                                          width: 30, // Ajuste a largura das barras aqui
                                          borderRadius: BorderRadius.circular(8), // Arredondar todos os cantos
                                          backDrawRodData: BackgroundBarChartRodData(show: false),
                                        ),
                                      ],
                                      showingTooltipIndicators: [],
                                    );
                                  }).toList(),
                                  titlesData: FlTitlesData(
                                    bottomTitles: SideTitles(
                                      showTitles: true,
                                      getTitles: (value) {
                                        final index = value.toInt();
                                        if (index > 0 && index <= provider.temperatureAverages.length) {
                                          final dayOfWeek = provider.temperatureAverages[index - 1].dayOfWeek;
                                          return dayOfWeek.substring(0, 3);
                                        }
                                        return '';
                                      },
                                      getTextStyles: (context, value) => const TextStyle(color: Colors.black),
                                      margin: 8,
                                    ),
                                    leftTitles: SideTitles(
                                      showTitles: true,
                                      getTitles: (value) {
                                        if (value % 10 == 0) {
                                          return value.toString();
                                        }
                                        return '';
                                      },
                                      getTextStyles: (context, value) => const TextStyle(color: Colors.black),
                                      margin: 8,
                                    ),
                                  ),
                                  gridData: FlGridData(
                                    show: false,
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                ),
                                swapAnimationDuration: const Duration(milliseconds: 500),
                                swapAnimationCurve: Curves.easeInOut,
                              ),
                            )
                          ),
                        ),
                      ],
                    ),
                  );
                }
                else{
                  return Text("Nenhuma medição encontrada");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}