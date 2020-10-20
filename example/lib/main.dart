import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optimizely_plugin/optimizely_plugin.dart';

Future<void> main() async {
  runApp(MyApp());
  await OptimizelyPlugin.initOptimizelyManager('your_optimizely_sdk_key');
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _flutterFlag = 'unknown';
  String _calculator = 'unknown';

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getFlutterFlag() async {
    String flutterFlag;
    // Platform messages may fail, so we use a try/catch PlatformException.
    var platform =
        Theme.of(context).platform.toString().split('.')[1].toLowerCase();
    try {
      bool featureEnabled = await OptimizelyPlugin.isFeatureEnabled(
        'flutter',
        'user@pg.com',
        {'platform': platform},
      );
      flutterFlag = 'flutter feature is $featureEnabled.';
    } on PlatformException catch (e) {
      flutterFlag = "Failed to get feature: '${e.message}'.";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _flutterFlag = flutterFlag;
    });
  }

  Future<void> getCalculatorType() async {
    String calculator;
    Map<String, dynamic> variables;
    var platform =
        Theme.of(context).platform.toString().split('.')[1].toLowerCase();
    try {
      variables = await OptimizelyPlugin.getAllFeatureVariables(
        'merlin_operations_calculator',
        'user@pg.com',
        {'platform': platform},
      );
      calculator = variables['calc_type'];
    } catch (e) {
      calculator = "Failed to get calculator type: '$e'.";
    }

    if (!mounted) return;

    setState(() {
      _calculator = calculator;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Optimizely example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text(_flutterFlag),
            ),
            RaisedButton(
              child: Text('Get Flutter Flag'),
              onPressed: () {
                getFlutterFlag();
              },
            ),
            Center(
              child: Text(_calculator),
            ),
            RaisedButton(
              child: Text('Get Calculator Type'),
              onPressed: () {
                getCalculatorType();
              },
            )
          ],
        ),
      ),
    );
  }
}
