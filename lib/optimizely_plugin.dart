import 'dart:async';

import 'package:flutter/services.dart';

class OptimizelyPlugin {
  static const MethodChannel _channel =
      const MethodChannel('optimizely_plugin');

  static Future<void> initOptimizelyManager(String sdkKey) async {
    await _channel.invokeMethod('initOptimizelyManager', <String, dynamic>{
      'sdk_key': sdkKey,
    });
  }

  static Future<bool> isFeatureEnabled(
    String featureKey,
    userID,
    Map<String, String> attributes,
  ) async {
    return await _channel.invokeMethod('isFeatureEnabled', <String, dynamic>{
      'feature_key': featureKey,
      'user_id': userID,
      'attributes': attributes
    });
  }

  static Future<Map<String, dynamic>> getAllFeatureVariables(
    String featureKey,
    userID,
    Map<String, String> attributes,
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
