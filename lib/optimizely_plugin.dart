import 'dart:async';
import 'package:flutter/services.dart';

class OptimizelyPlugin {
  const OptimizelyPlugin();

  static const MethodChannel _channel =
      const MethodChannel('optimizely_plugin');

  Future<void> initOptimizelyManager(
    String sdkKey,
    String dataFile,
  ) async {
    await _channel.invokeMethod('initOptimizelyManager', <String, dynamic>{
      'sdk_key': sdkKey,
      'datafile': dataFile,
    });
  }

  Future<bool> isFeatureEnabled(
    String featureKey,
    userID,
    Map<String, dynamic> attributes,
  ) async {
    return await _channel.invokeMethod('isFeatureEnabled', <String, dynamic>{
      'feature_key': featureKey,
      'user_id': userID,
      'attributes': attributes
    });
  }

  Future<Map<String, dynamic>> getAllFeatureVariables(
    String featureKey,
    userID,
    Map<String, dynamic> attributes,
  ) async {
    final featureVariables =
        await _channel.invokeMethod('getAllFeatureVariables', <String, dynamic>{
      'feature_key': featureKey,
      'user_id': userID,
      'attributes': attributes,
    });
    return Map<String, dynamic>.from(featureVariables);
  }
}
