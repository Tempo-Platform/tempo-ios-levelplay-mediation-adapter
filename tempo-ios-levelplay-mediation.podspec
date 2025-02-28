#
# Run `pod spec lint tempo-ios-levelplay-mediation.podspec' to validate the spec after any changes
#
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
  spec.name          = 'tempo-ios-levelplay-mediation'
  spec.version       = '1.1.1-rc.0'
  spec.swift_version = '5.6.1'
  spec.author        = { 'Tempo Engineering' => 'development@tempoplatform.com' }
  spec.license       = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  spec.homepage      = 'https://www.tempoplatform.com'
  spec.readme        = 'https://github.com/Tempo-Platform/tempo-ios-levelplay-mediation-adapter/blob/main/README.md'
  spec.source        = { :git => 'https://github.com/Tempo-Platform/tempo-ios-levelplay-mediation-adapter.git', :tag => spec.version.to_s }
  spec.summary       = 'Tempo LevelPlay iOS Mediation Adapter.'
  spec.description   = <<-DESC
  Using this adapter you will be able to integrate Tempo SDK via LevelPlay mediation
                   DESC

  spec.platform     = :ios, '13.0'

  spec.source_files = 'TempoAdapter/*.*'
  spec.resource_bundles = {
      'TempoAdapter' => ['TempoAdapter/Resources/**/*']
    }

  spec.dependency 'TempoSDK', '1.8.3'
  spec.dependency 'IronSourceSDK', '~> 8.7'
  spec.requires_arc     = true
  spec.frameworks       = 'Foundation', 'UIKit'
  spec.static_framework = true
  spec.script_phase     = {
     :name => 'Hello ',
     :script => 'echo "Adding Custom Module Header" && touch Headers/tempo_ios_levelplay_mediation.h && echo "#import <IronSource/IronSource.h>" >> Headers/tempo_ios_levelplay_mediation.h',
     :execution_position => :after_compile
   }

  spec.pod_target_xcconfig  = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.pod_target_xcconfig  = { 'PRODUCT_BUNDLE_IDENTIFIER': 'com.tempoplatform.lp-adapter-sdk' }
end
