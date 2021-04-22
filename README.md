# optimizely_plugin

[![pub package](https://img.shields.io/pub/v/optimizely_plugin.svg)](https://pub.dev/packages/optimizely_plugin) [![pub points](https://badges.bar/optimizely_plugin/pub%20points)](https://pub.dev/packages/optimizely_plugin/score) [![likes](https://badges.bar/optimizely_plugin/likes)](https://pub.dev/packages/optimizely_plugin/score) [![popularity](https://badges.bar/optimizely_plugin/popularity)](https://pub.dev/packages/optimizely_plugin/score)

Flutter plugin for Optimizely native SDKs

## Getting Started

Currently [Optimizely](https://www.optimizely.com/) does not offer a dedicated flutter SDK. This flutter plugin is bridging the gap between a flutter application and the native optimizely [FULL STACK SDKs](https://docs.developers.optimizely.com/full-stack/docs) for [Android](https://docs.developers.optimizely.com/full-stack/docs/android-sdk) and [iOS](https://docs.developers.optimizely.com/full-stack/docs/swift-sdk). 

## Usage

This plugin is work in progress and as of right now has a very limited functionality focused on solely on Optimizely [rollouts](https://docs.developers.optimizely.com/full-stack/docs/introduction-to-rollouts).

Two functions are supported:[`isFeatureEnabled`](https://docs.developers.optimizely.com/full-stack/docs/is-feature-enabled-android) and [`getAllFeatureVariables`](https://docs.developers.optimizely.com/full-stack/docs/get-all-feature-variables-android).
```dart
import 'package:optimizely_plugin/optimizely_plugin.dart';
...
await OptimizelyPlugin.initOptimizelyManager('your_optimizely_sdk_key');
bool featureEnabled = await OptimizelyPlugin.isFeatureEnabled('your_flag', 'some_user@xyz.com');
...
Map<String, dynamic> variables = await OptimizelyPlugin.getAllFeatureVariables(
  'your_flag_with_vars',
  'some_user@xyz.com',
  {'attribute_key': attribute_value},
);
String variable_value = variables['variable_name'];
```
The example application shows how to use these functions in more detail.  Before you can run the sample application you would need to:
 
 - create Optimizely rollouts project and get the SDK key for the environment you want to test
 - create a [simple flag](https://docs.developers.optimizely.com/full-stack/docs/create-feature-flags)
   ![Simple Flag](https://user-images.githubusercontent.com/46966906/101215706-48b26f80-364c-11eb-8dc7-e8d7a0d7b861.png)
 - create a [flag with variables](https://docs.developers.optimizely.com/full-stack/docs/create-feature-variables)
   ![Flag With Variables](https://user-images.githubusercontent.com/46966906/101215717-4e0fba00-364c-11eb-8e49-cd43e03a60fb.png)

## Installation

Add `optimizely_plugin` as a dependency in your project's `pubspec.yaml`

```
dependencies:
  optimizely_plugin: ^0.1.3
```

Then run `flutter pub get` in your project directory
