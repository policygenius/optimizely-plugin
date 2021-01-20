#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint optimizely_plugin.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'optimizely_plugin'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for Optimizely SDK'
  s.description      = <<-DESC
Flutter plugin for optimizely SDK
                       DESC
  s.homepage         = 'https://policygenius.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Policygenius' => 'support@policygenius.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'OptimizelySwiftSDK', '~> 3.6.1'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
