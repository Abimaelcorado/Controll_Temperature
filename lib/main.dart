import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'screens/homepage.dart';
import 'screens/setings.dart';
import 'package:provider/provider.dart';
import './screens/temperatura_provider.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => ChangeNotifierProvider(
        create: (context) => TemperaturaProvider(),
        child: const MaterialApp(
          builder: DevicePreview.appBuilder,
          home: MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String galpaoName = "Galpão";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(galpaoName: galpaoName),
      routes: {
        "/settings": (context) => SettingsPage(
              galpaoName: galpaoName,
              onNameChanged: (newName) {
                setState(() {
                  galpaoName = newName;
                });
              },
            ),
      },
    );
  }
}
