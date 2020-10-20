package com.policygenius.optimizely_plugin

import android.app.Activity
import androidx.annotation.NonNull
import com.noveogroup.android.log.Log
import com.optimizely.ab.android.sdk.OptimizelyManager
import com.optimizely.ab.optimizelyjson.OptimizelyJSON
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.Console

/** OptimizelyPlugin */
class OptimizelyPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var activity: Activity
  private lateinit var optimizelyManager: OptimizelyManager

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "optimizely_plugin")
    channel.setMethodCallHandler(this);
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "optimizely_plugin")
      channel.setMethodCallHandler(OptimizelyPlugin())
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "isFeatureEnabled") {
      val featureKey = call.argument<String>("feature_key")
      val userId = call.argument<String>("user_id")
      val flag = isFeatureEnabled(featureKey!!, userId!!)
      result.success(flag)
    } else if (call.method == "initOptimizelyManager") {
      val sdkKey = call.argument<String>("sdk_key")
      initOptimizelyManager(sdkKey!!)
      result.success("")
    } else if (call.method == "getAllFeatureVariables") {
      val featureKey = call.argument<String>("feature_key")
      val userId = call.argument<String>("user_id")
      val attributes = call.argument<MutableMap<String,Any>>("attributes")
      val variables = getAllFeatureVariables(featureKey!!,userId!!,attributes!!)
      result.success(variables)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  private fun initOptimizelyManager(sdkKey: String) {
    val builder = OptimizelyManager.builder()
    // In Android, the minimum polling interval is 60 seconds. In iOS, the minimum polling
    // interval is 2 minutes while the app is open. If you specify shorter polling intervals
    // than these minimums, the SDK will automatically reset the intervals to 60 seconds (Android)
    // or 2 minutes (iOS).
    optimizelyManager = builder.withDatafileDownloadInterval(60)
            .withSDKKey(sdkKey)
            .build(activity.applicationContext)
  }

  private fun isFeatureEnabled(featureKey: String, userId: String): Boolean{
    // Updated datafiles do not take effect until your app is restarted or when you re-initialize
    // the Optimizely manager. This implementation strategy allows the data to change while the
    // app is running without causing nondeterministic behavior.
    val client = optimizelyManager.initialize(activity.applicationContext, R.raw.datafile)
    val flag = client.isFeatureEnabled(featureKey, userId)

    return flag
  }

  private fun getAllFeatureVariables(featureKey: String, userId: String, attributes: MutableMap<String, Any>): Map<String, Any>? {
    // Updated datafiles do not take effect until your app is restarted or when you re-initialize
    // the Optimizely manager. This implementation strategy allows the data to change while the
    // app is running without causing nondeterministic behavior.
    val client = optimizelyManager.initialize(activity.applicationContext, R.raw.datafile)

    val json = client.getAllFeatureVariables(featureKey, userId, attributes)
    return json?.toMap()
  }
}
