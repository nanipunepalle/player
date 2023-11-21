# Be sure to run `pod lib lint PlayerUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PlayerUI'
  s.version          = '0.0.1-placeholder'
  s.summary          = 'A native renderer for Player content'
  s.swift_versions   = ['5.1']
  s.description      = <<-DESC
This package is used to process semantic JSON in the Player format
and display it as a SwiftUI view comprised of registered assets.
                       DESC

  s.homepage         = 'https://github.com/player-ui/player'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hborawski' => 'harris_borawski@intuit.com' }
  s.source         = { :http => "https://github.com/player-ui/player/releases/download/#{s.version.to_s}/PlayerUI_Pod.zip" }

  s.ios.deployment_target = '14.0'

  s.default_subspec = 'Main'

  s.subspec 'Main' do |all|
    all.dependency 'PlayerUI/SwiftUI'
  end

  # <INTERNAL>
  s.app_spec 'Demo' do |demo|
    demo.source_files = 'xcode/demo/**/*.swift'

    demo.resources = [
      'xcode/demo/Resources/Primary.storyboard',
      'xcode/demo/Resources/Launch.xib',
      'xcode/demo/Resources/**/*.xcassets'
    ]

    demo.dependency 'PlayerUI/SwiftUI'
    demo.dependency 'PlayerUI/BeaconPlugin'
    demo.dependency 'PlayerUI/ReferenceAssets'
    demo.dependency 'PlayerUI/MetricsPlugin'
    demo.dependency 'PlayerUI/TransitionPlugin'

    demo.info_plist = {
      'UILaunchStoryboardName' => 'Launch',
      'CFBundleIdentifier' => 'com.intuit.ios.player',
      'UIApplicationSceneManifest' => {
        'UIApplicationSupportsMultipleScenes' => true,
        'UISceneConfigurations' => {
          'UIWindowSceneSessionRoleApplication' => [
            {
              'UISceneConfigurationName' => 'Default Configuration',
              'UISceneDelegateClassName' => 'PlayerUI_Demo.SceneDelegate'
            }
          ]
        }
      }
    }

    demo.pod_target_xcconfig = {
      'PRODUCT_BUNDLE_IDENTIFIER': 'com.intuit.ios.player',

      'CODE_SIGN_STYLE': 'Manual',
      'CODE_SIGN_IDENTITY': 'iPhone Distribution',
      'PROVISIONING_PROFILE_SPECIFIER': 'match InHouse com.intuit.ios.player',
      'DEVELOPMENT_TEAM': 'F6DWWXWEX6',

      'SKIP_INSTALL': 'NO',
      'SKIP_INSTALLED_PRODUCT': 'YES'
    }

    demo.script_phases = [
        {
          :name => 'SwiftLint',
          :execution_position => :before_compile,
          :script => <<-SCRIPT
            cd ${SRCROOT}/../..
            ${PODS_ROOT}/SwiftLint/swiftlint --config .swiftlint.yml --path ./ios/
          SCRIPT
        },
        {
        :name => 'Mock Generation',
        :execution_position => :before_compile,
        :shell_path => '/bin/zsh',
        :script => <<-SCRIPT
          cd ${SRCROOT}/../../ios/packages/demo/scripts
          if test -f ~/.zshrc; then
            source ~/.zshrc
          fi
          ./generateFlowSections.js
        SCRIPT
      }
    ]
  end

  s.subspec 'InternalUnitTestUtilities' do |utils|
    utils.dependency 'PlayerUI/Core'
    utils.source_files = 'ios/TestUtilities/internal-test-utils/**/*'

    utils.weak_framework = 'XCTest'
    utils.pod_target_xcconfig = {
      'ENABLE_BITCODE' => 'NO',
      'ENABLE_TESTING_SEARCH_PATHS' => 'YES'
    }
  end

  s.test_spec 'Unit' do |tests|
    tests.requires_app_host = true
    tests.app_host_name = 'PlayerUI/Demo'
    tests.dependency 'PlayerUI/InternalUnitTestUtilities'
    tests.dependency 'PlayerUI/Demo'
    tests.dependency 'PlayerUI/TestUtilities'
    tests.source_files = [
      'ios/Tests/**/*.swift'
    ]
  end

  s.test_spec 'ViewInspectorTests' do |tests|
    tests.test_type = :ui
    tests.requires_app_host = true
    tests.app_host_name = 'PlayerUI/Demo'
    tests.dependency 'PlayerUI/InternalUnitTestUtilities'
    tests.dependency 'PlayerUI/Demo'
    tests.dependency 'ViewInspector', '0.9.0'
    tests.source_files = [
      'ios/ViewInspector/**/*',

      # Mocks from demo app
      'ios/packages/demo/Sources/MockFlows.swift'
    ]
    # tests.resources = ['ios/Sources/packages/test-utils/viewinspector/ui-test/mocks']

    tests.pod_target_xcconfig = {
      'PRODUCT_BUNDLE_IDENTIFIER': 'com.intuit.ios.PlayerUI-ExampleUITests',

      'CODE_SIGN_STYLE': 'Manual',
      'CODE_SIGN_IDENTITY[sdk=iphoneos*]': 'iPhone Developer',
      'PROVISIONING_PROFILE_SPECIFIER': 'match Development com.intuit.ios.PlayerUI-ExampleUITests*',
      'DEVELOPMENT_TEAM': 'F6DWWXWEX6'
    }
  end

  s.test_spec 'XCUITests' do |tests|
    tests.test_type = :ui
    tests.requires_app_host = true
    tests.app_host_name = 'PlayerUI/Demo'
    tests.dependency 'PlayerUI/InternalUnitTestUtilities'
    tests.dependency 'PlayerUI/Demo'
    tests.dependency 'EyesXCUI', '8.8.8'
    tests.source_files = [
      'ios/XCUI/**/*'
    ]

    tests.pod_target_xcconfig = {
      'PRODUCT_BUNDLE_IDENTIFIER': 'com.intuit.ios.PlayerUI-ExampleUITests',

      'CODE_SIGN_STYLE': 'Manual',
      'CODE_SIGN_IDENTITY[sdk=iphoneos*]': 'iPhone Developer',
      'PROVISIONING_PROFILE_SPECIFIER': 'match Development com.intuit.ios.PlayerUI-ExampleUITests*',
      'DEVELOPMENT_TEAM': 'F6DWWXWEX6'
    }
  end

  # </INTERNAL>

  # <PACKAGES>
  s.subspec 'Core' do |core|
    core.source_files = 'ios/Sources/packages/core/**/*.swift'
    core.dependency 'SwiftHooks', '~> 0', '>= 0.1.0'
    core.dependency 'PlayerUI/Logger'
    core.resource_bundles = {
      'PlayerUI' => ['ios/Sources/packages/core/Resources/**/*.js']
    }
  end

  s.subspec 'TestUtilitiesCore' do |utils|
    utils.dependency 'PlayerUI/Core'
    utils.dependency 'PlayerUI/SwiftUI'

    utils.source_files = 'ios/Sources/packages/test-utils-core/**/*.swift'
    utils.resource_bundles = {
      'TestUtilities' => ['ios/Sources/packages/test-utils-core/Resources/**/*.js']
    }
  end

  s.subspec 'TestUtilities' do |utils|
    utils.dependency 'PlayerUI/Core'
    utils.dependency 'PlayerUI/SwiftUI'
    utils.dependency 'PlayerUI/TestUtilitiesCore'

    utils.source_files = 'ios/Sources/packages/test-utils/**/*.swift'

    utils.weak_framework = 'XCTest'
    utils.pod_target_xcconfig = {
      'ENABLE_BITCODE' => 'NO',
      'ENABLE_TESTING_SEARCH_PATHS' => 'YES'
    }
  end

  s.subspec 'ReferenceAssets' do |assets|
    assets.dependency 'PlayerUI/Core'
    assets.dependency 'PlayerUI/SwiftUI'
    assets.dependency 'PlayerUI/BeaconPlugin'
    assets.dependency 'PlayerUI/SwiftUIPendingTransactionPlugin'

    assets.source_files = 'ios/Sources/packages/reference-assets/**/*.swift'
    assets.resource_bundles = {
      'ReferenceAssets' => [
        'ios/packages/Sources/reference-assets/Resources/js/**/*.js',
        'ios/packages/Sources/reference-assets/Resources/svg/*.xcassets',

        # This should be generated by cocoapods-bazel in the build file, but isn't for some reason
        'ios/packages/Sources/reference-assets/Resources/svg/*.xcassets/**/*'
      ]
    }
  end

  s.subspec 'SwiftUI' do |swiftui|
    swiftui.dependency 'PlayerUI/Core'

    swiftui.source_files = 'ios/Sources/packages/swiftui/**/*.swift'
  end

  s.subspec 'Logger' do |pkg|
    pkg.dependency 'SwiftHooks', '~> 0', '>= 0.1.0'
    pkg.source_files = 'ios/Sources/packages/logger/**/*.swift'
  end
  # </PACKAGES>

  # <PLUGINS>
  s.subspec 'PrintLoggerPlugin' do |plugin|
    plugin.dependency 'PlayerUI/Core'
    plugin.source_files = 'ios/Sources/plugins/PrintLoggerPlugin/**/*.swift'
  end

  s.subspec 'TransitionPlugin' do |plugin|
    plugin.dependency 'PlayerUI/Core'
    plugin.dependency 'PlayerUI/SwiftUI'
    plugin.source_files = 'ios/Sources/plugins/TransitionPlugin/**/*.swift'
  end

  s.subspec 'BaseBeaconPlugin' do |plugin|
    plugin.dependency 'PlayerUI/Core'
    plugin.source_files = 'ios/Sources/plugins/BaseBeaconPlugin/**/*.swift'
    plugin.resource_bundles = {
      'BaseBeaconPlugin' => ['ios/Sources/plugins/BaseBeaconPlugin/Resources/**/*.js']
    }
  end

  s.subspec 'BeaconPlugin' do |plugin|
    plugin.dependency 'PlayerUI/Core'
    plugin.dependency 'PlayerUI/SwiftUI'
    plugin.dependency 'PlayerUI/BaseBeaconPlugin'
    plugin.source_files = 'ios/Sources/plugins/BeaconPlugin/**/*.swift'
  end

  s.subspec 'CheckPathPlugin' do |plugin|
    plugin.dependency 'PlayerUI/Core'
    plugin.source_files = 'ios/Sources/plugins/CheckPathPlugin/**/*.swift'
    plugin.resource_bundles = {
      'CheckPathPlugin' => ['ios/Sources/plugins/CheckPathPlugin/Resources/**/*.js']
    }
  end

  s.subspec 'CommonTypesPlugin' do |plugin|
    plugin.dependency 'PlayerUI/Core'
    plugin.source_files = 'ios/Sources/plugins/CommonTypesPlugin/**/*.swift'
    plugin.resource_bundles = {
      'CommonTypesPlugin' => ['ios/Sources/plugins/CommonTypesPlugin/Resources/**/*.js']
    }
  end

  s.subspec 'ComputedPropertiesPlugin' do |plugin|
    plugin.dependency 'PlayerUI/Core'
    plugin.source_files = 'ios/Sources/plugins/ComputedPropertiesPlugin/**/*.swift'
    plugin.resource_bundles = {
      'ComputedPropertiesPlugin' => ['ios/Sources/plugins/ComputedPropertiesPlugin/Resources/**/*.js']
    }
  end

  s.subspec 'CommonExpressionsPlugin' do |plugin|
    plugin.dependency 'PlayerUI/Core'
    plugin.source_files = 'ios/Sources/plugins/CommonExpressionsPlugin/**/*.swift'
    plugin.resource_bundles = {
      'CommonExpressionsPlugin' => ['ios/Sources/plugins/CommonExpressionsPlugin/Resources/**/*.js']
    }
  end

  s.subspec 'ExpressionPlugin' do |plugin|
    plugin.dependency 'PlayerUI/Core'
    plugin.source_files = 'ios/Sources/plugins/ExpressionPlugin/**/*.swift'
    plugin.resource_bundles = {
      'ExpressionPlugin' => ['ios/Sources/plugins/ExpressionPlugin/Resources/**/*.js']
    }
  end

  s.subspec 'ExternalActionPlugin' do |plugin|
    plugin.dependency 'PlayerUI/Core'
    plugin.source_files = 'ios/Sources/plugins/ExternalActionPlugin/**/*.swift'
    plugin.resource_bundles = {
      'ExternalActionPlugin' => ['ios/Sources/plugins/ExternalActionPlugin/Resources/**/*.js']
    }
  end

  s.subspec 'ExternalActionViewModifierPlugin' do |plugin|
    plugin.dependency 'PlayerUI/Core'
    plugin.dependency 'PlayerUI/SwiftUI'
    plugin.dependency 'PlayerUI/ExternalActionPlugin'
    plugin.source_files = 'ios/Sources/plugins/ExternalActionViewModifierPlugin/**/*.swift'
  end

  s.subspec 'MetricsPlugin' do |plugin|
    plugin.dependency 'PlayerUI/Core'
    plugin.dependency 'PlayerUI/SwiftUI'
    plugin.source_files = 'ios/Sources/plugins/MetricsPlugin/**/*.swift'
    plugin.resource_bundles = {
      'MetricsPlugin' => ['ios/Sources/plugins/MetricsPlugin/Resources/**/*.js']
    }
  end

  s.subspec 'PubSubPlugin' do |plugin|
    plugin.dependency 'PlayerUI/Core'
    plugin.source_files = 'ios/Sources/plugins/PubSubPlugin/**/*.swift'
    plugin.resource_bundles = {
      'PubSubPlugin' => ['ios/Sources/plugins/PubSubPlugin/Resources/**/*.js']
    }
  end

  s.subspec 'StageRevertDataPlugin' do |plugin|
    plugin.dependency 'PlayerUI/Core'
    plugin.source_files = 'ios/Sources/plugins/StageRevertDataPlugin/**/*.swift'
    plugin.resource_bundles = {
      'StageRevertDataPlugin' => ['ios/Sources/plugins/StageRevertDataPlugin/Resources/**/*.js']
    }
  end

  s.subspec 'SwiftUICheckPathPlugin' do |plugin|
    plugin.dependency 'PlayerUI/Core'
    plugin.dependency 'PlayerUI/SwiftUI'
    plugin.dependency 'PlayerUI/CheckPathPlugin'
    plugin.source_files = 'ios/Sources/plugins/SwiftUICheckPathPlugin/**/*.swift'
  end

  s.subspec 'SwiftUIPendingTransactionPlugin' do |plugin|
    plugin.dependency 'PlayerUI/Core'
    plugin.dependency 'PlayerUI/SwiftUI'
    plugin.source_files = 'ios/Sources/plugins/SwiftUIPendingTransactionPlugin/**/*.swift'
  end

  s.subspec 'TypesProviderPlugin' do |plugin|
    plugin.dependency 'PlayerUI/Core'
    plugin.source_files = 'ios/Sources/plugins/TypesProviderPlugin/**/*.swift'
    plugin.resource_bundles = {
      'TypesProviderPlugin' => ['ios/Sources/plugins/TypesProviderPlugin/Resources/**/*.js']
    }
  end
  # </PLUGINS>
end
