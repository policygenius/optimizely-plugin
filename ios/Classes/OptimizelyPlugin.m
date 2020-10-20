#import "OptimizelyPlugin.h"
#if __has_include(<optimizely_plugin/optimizely_plugin-Swift.h>)
#import <optimizely_plugin/optimizely_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "optimizely_plugin-Swift.h"
#endif

@implementation OptimizelyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOptimizelyPlugin registerWithRegistrar:registrar];
}
@end
