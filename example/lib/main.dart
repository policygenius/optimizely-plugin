import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optimizely_plugin/optimizely_plugin.dart';

Future<void> main() async {
  runApp(MyApp());
  // Uses the Optimizely example:
  // https://docs.developers.optimizely.com/full-stack/docs/example-datafile
  final dataFile = await rootBundle.loadString('assets/datafile.json');
  await OptimizelyPlugin.initOptimizelyManager(
    'your_optimizely_sdk_key',
    dataFile,
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _priceFilterFlag = 'unknown';
  String _minPriceVariable = 'unknown';

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getPriceFilterFlag() async {
    String priceFilterFlag;
    // Platform messages may fail, so we use a try/catch PlatformException.
    var platform =
        Theme.of(context).platform.toString().split('.')[1].toLowerCase();
    try {
      bool featureEnabled = await OptimizelyPlugin.isFeatureEnabled(
        'price_filter',
        'user@example.org',
        {'platform': platform},
      );
      priceFilterFlag = 'price_filter feature is $featureEnabled.';
    } on PlatformException catch (e) {
      priceFilterFlag = "Failed to get feature: '${e.message}'.";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _priceFilterFlag = priceFilterFlag;
    });
  }

  Future<void> getPriceFilterMinPrice() async {
    String minPriceVariable;
    Map<String, dynamic> variables;
    var platform =
        Theme.of(context).platform.toString().split('.')[1].toLowerCase();
    try {
      variables = await OptimizelyPlugin.getAllFeatureVariables(
        'price_filter',
        'user@example.org',
        {'platform': platform},
      );
      int minPrice = variables['min_price'];
      minPriceVariable = "min_price variable is: ${minPrice.toString()}.";
    } catch (e) {
      minPriceVariable = "Failed to get min_price variable from feature: '$e'.";
    }

    if (!mounted) return;

    setState(() {
      _minPriceVariable = minPriceVariable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Optimizely Example App'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 32),
              Center(
                child: Text(_priceFilterFlag),
              ),
              RaisedButton(
                child: Text('Get Price Filter Flag'),
                onPressed: () {
                  getPriceFilterFlag();
                },
              ),
              SizedBox(height: 16),
              Center(
                child: Text(_minPriceVariable),
              ),
              RaisedButton(
                child: Text('Get Price Filter Min Price'),
                onPressed: () {
                  getPriceFilterMinPrice();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
