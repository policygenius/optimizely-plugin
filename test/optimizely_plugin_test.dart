import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:optimizely_plugin/optimizely_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('optimizely_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'initOptimizelyManager':
          break;
        case 'isFeatureEnabled':
          var featureKey = methodCall.arguments['feature_key'];
          var userId = methodCall.arguments['user_id'];
          if (userId == 'user@pg.com' && featureKey == 'flutter') {
            return true;
          }
          return false;
        case 'getAllFeatureVariables':
          var featureKey = methodCall.arguments['feature_key'];
          var userId = methodCall.arguments['user_id'];
          var attributes = methodCall.arguments['attributes'];
          if (featureKey == 'calculator' && userId == 'user@pg.com') {
            switch (attributes['platform']) {
              case 'ios':
                return {'calc_type': 'scientific'};
              case 'android':
                return {'calc_type': 'basic'};
              default:
                return {};
            }
          }
          return {};
        default:
          break;
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('initOptimizelyManager', () async {
    try {
      OptimizelyPlugin.initOptimizelyManager('sdkKey');
    } on PlatformException catch (error) {
      throw error;
    }
  });

  test('isFeatureEnabled', () async {
    final enabled = await OptimizelyPlugin.isFeatureEnabled(
      'flutter',
      'user@pg.com',
      {'platform': 'android'},
    );
    expect(enabled, true);
  });

  test('getAllFeatureVariablesAndroid', () async {
    var features = await OptimizelyPlugin.getAllFeatureVariables(
      'calculator',
      'user@pg.com',
      {'platform': 'android'},
    );
    expect(features['calc_type'], 'basic');
  });

  test('getAllFeatureVariablesApple', () async {
    var features = await OptimizelyPlugin.getAllFeatureVariables(
      'calculator',
      'user@pg.com',
      {'platform': 'ios'},
    );
    expect(features['calc_type'], 'scientific');
  });
}
