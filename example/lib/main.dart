import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_electricity_meter/electricity_meter/electricity_manager.dart';
import 'package:flutter_electricity_meter/electricity_meter/electricity_meter_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final manager = ElectricityMeterManager(maxValue: 100000);

  @override
  void dispose() {
    manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElectricityMeter(
            width: MediaQuery.of(context).size.width,
            manager: manager,
            colors: const [
              Color(0xFFfb0505),
              Color(0xFFfb7607),
              Color(0xFFf4ea07),
              Color(0xFF61f205),
              Color(0xFF00f6cb),
            ],
          ),
          ValueListenableBuilder(
              valueListenable: manager.currentValue,
              builder: (context, value, child) => Text(
                    '$value',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  )),
          OutlinedButton(
              onPressed: () => manager.onChange(Random().nextInt(100000)),
              child: Text('test'))
        ],
      ),
    );
  }
}
