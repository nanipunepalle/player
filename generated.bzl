load("@build_bazel_rules_ios//rules:app.bzl", "ios_application")
load("@build_bazel_rules_ios//rules:framework.bzl", "apple_framework")
load(
    "@build_bazel_rules_ios//rules:test.bzl",
    "ios_ui_test",
    "ios_unit_test",
)

glob = native.glob

def PlayerUI(
    deps
):
    apple_framework(
        name = "PlayerUI",
        swift_version = "5.1",
        xcconfig = {
            "ENABLE_BITCODE": "NO",
            "ENABLE_TESTING_SEARCH_PATHS": "YES",
        },
        srcs = glob([
            "ios/Sources/plugins/BaseBeaconPlugin/**/*.swift",
            "ios/Sources/plugins/BeaconPlugin/**/*.swift",
            "ios/Sources/plugins/CheckPathPlugin/**/*.swift",
            "ios/Sources/plugins/CommonExpressionsPlugin/**/*.swift",
            "ios/Sources/plugins/CommonTypesPlugin/**/*.swift",
            "ios/Sources/plugins/ComputedPropertiesPlugin/**/*.swift",
            "ios/Sources/packages/core/**/*.swift",
            "ios/Sources/plugins/ExpressionPlugin/**/*.swift",
            "ios/Sources/plugins/ExternalActionPlugin/**/*.swift",
            "ios/Sources/plugins/ExternalActionViewModifierPlugin/**/*.swift",
            "ios/TestUtilities/internal-test-utils/**/*.h",
            "ios/TestUtilities/internal-test-utils/**/*.hh",
            "ios/TestUtilities/internal-test-utils/**/*.m",
            "ios/TestUtilities/internal-test-utils/**/*.mm",
            "ios/TestUtilities/internal-test-utils/**/*.swift",
            "ios/TestUtilities/internal-test-utils/**/*.c",
            "ios/TestUtilities/internal-test-utils/**/*.cc",
            "ios/TestUtilities/internal-test-utils/**/*.cpp",
            "ios/Sources/packages/logger/**/*.swift",
            "ios/Sources/plugins/MetricsPlugin/**/*.swift",
            "ios/Sources/plugins/PrintLoggerPlugin/**/*.swift",
            "ios/Sources/plugins/PubSubPlugin/**/*.swift",
            "ios/Sources/packages/reference-assets/**/*.swift",
            "ios/Sources/plugins/StageRevertDataPlugin/**/*.swift",
            "ios/Sources/packages/swiftui/**/*.swift",
            "ios/Sources/plugins/SwiftUICheckPathPlugin/**/*.swift",
            "ios/Sources/plugins/SwiftUIPendingTransactionPlugin/**/*.swift",
            "ios/Sources/packages/test-utils/**/*.swift",
            "ios/Sources/packages/test-utils-core/**/*.swift",
            "ios/Sources/plugins/TransitionPlugin/**/*.swift",
            "ios/Sources/plugins/TypesProviderPlugin/**/*.swift",
        ]),
        resource_bundles = {
            "BaseBeaconPlugin": glob(
                [
                    "ios/Sources/plugins/BaseBeaconPlugin/Resources/**/*.js",
                ],
                exclude_directories = 0,
            ),
            "CheckPathPlugin": glob(
                [
                    "ios/Sources/plugins/CheckPathPlugin/Resources/**/*.js",
                ],
                exclude_directories = 0,
            ),
            "CommonExpressionsPlugin": glob(
                [
                    "ios/Sources/plugins/CommonExpressionsPlugin/Resources/**/*.js",
                ],
                exclude_directories = 0,
            ),
            "CommonTypesPlugin": glob(
                [
                    "ios/Sources/plugins/CommonTypesPlugin/Resources/**/*.js",
                ],
                exclude_directories = 0,
            ),
            "ComputedPropertiesPlugin": glob(
                [
                    "ios/Sources/plugins/ComputedPropertiesPlugin/Resources/**/*.js",
                ],
                exclude_directories = 0,
            ),
            "PlayerUI": glob(
                ["ios/Sources/packages/core/Resources/**/*.js"],
                exclude_directories = 0,
            ),
            "ExpressionPlugin": glob(
                [
                    "ios/Sources/plugins/ExpressionPlugin/Resources/**/*.js",
                ],
                exclude_directories = 0,
            ),
            "ExternalActionPlugin": glob(
                [
                    "ios/Sources/plugins/ExternalActionPlugin/Resources/**/*.js",
                ],
                exclude_directories = 0,
            ),
            "MetricsPlugin": glob(
                [
                    "ios/Sources/plugins/MetricsPlugin/Resources/**/*.js",
                ],
                exclude_directories = 0,
            ),
            "PubSubPlugin": glob(
                ["ios/Sources/plugins/PubSubPlugin/Resources/**/*.js"],
                exclude_directories = 0,
            ),
            "ReferenceAssets": glob(
                [
                    "ios/packages/Sources/reference-assets/Resources/js/**/*.js",
                    "ios/packages/Sources/reference-assets/Resources/svg/*.xcassets",
                    "ios/packages/Sources/reference-assets/Resources/svg/*.xcassets/**/*",
                ],
                exclude_directories = 0,
            ),
            "StageRevertDataPlugin": glob(
                [
                    "ios/Sources/plugins/StageRevertDataPlugin/Resources/**/*.js",
                ],
                exclude_directories = 0,
            ),
            "TestUtilities": glob(
                [
                    "ios/Sources/packages/test-utils-core/Resources/**/*.js",
                ],
                exclude_directories = 0,
            ),
            "TypesProviderPlugin": glob(
                [
                    "ios/Sources/plugins/TypesProviderPlugin/Resources/**/*.js",
                ],
                exclude_directories = 0,
            ),
        },
        weak_sdk_frameworks = ["XCTest"],
        deps = ["@Pods//SwiftHooks"] + deps,
        visibility = ["//visibility:public"],
        platforms = {"ios": "14.0"},
    )

def PlayerUI_Demo(
    deps
):
    ios_application(
        name = "PlayerUI-Demo",
        module_name = "PlayerUI_Demo",
        data = glob(
            [
                "xcode/demo/Resources/Primary.storyboard",
                "xcode/demo/Resources/Primary.storyboard/**/*",
                "xcode/demo/Resources/Launch.xib",
                "xcode/demo/Resources/Launch.xib/**/*",
                "xcode/demo/Resources/**/*.xcassets",
                "xcode/demo/Resources/**/*.xcassets/**/*",
            ],
            exclude_directories = 0,
        ),
        swift_version = "5.1",
        xcconfig = {
            "ENABLE_BITCODE": "NO",
            "ENABLE_TESTING_SEARCH_PATHS": "YES",
            "PRODUCT_BUNDLE_IDENTIFIER": "com.intuit.ios.player",
            "CODE_SIGN_STYLE": "Manual",
            "CODE_SIGN_IDENTITY": "iPhone Distribution",
            "PROVISIONING_PROFILE_SPECIFIER": "match InHouse com.intuit.ios.player",
            "DEVELOPMENT_TEAM": "F6DWWXWEX6",
            "SKIP_INSTALL": "NO",
            "SKIP_INSTALLED_PRODUCT": "YES",
        },
        srcs = glob(["xcode/demo/**/*.swift"]),
        deps = [":PlayerUI"] + deps,
        bundle_id = "com.intuit.ios.player",
        families = [
            "iphone",
            "ipad",
        ],
        infoplists = [
            {
                "UILaunchStoryboardName": "Launch",
                "CFBundleIdentifier": "com.intuit.ios.player",
                "UIApplicationSceneManifest": {
                    "UIApplicationSupportsMultipleScenes": True,
                    "UISceneConfigurations": {"UIWindowSceneSessionRoleApplication": [
                        {
                            "UISceneConfigurationName": "Default Configuration",
                            "UISceneDelegateClassName": "PlayerUI_Demo.SceneDelegate",
                        },
                    ]},
                },
            },
        ],
        minimum_os_version = "14.0",
    )

def unit_tests(
):
    ios_unit_test(
        name = "PlayerUI-Unit-Unit",
        module_name = "PlayerUI_Unit_Unit",
        swift_version = "5.1",
        xcconfig = {
            "ENABLE_BITCODE": "NO",
            "ENABLE_TESTING_SEARCH_PATHS": "YES",
        },
        srcs = glob(["ios/Tests/**/*.swift"]),
        deps = [":PlayerUI"],
        minimum_os_version = "14.0",
        test_host = ":PlayerUI-Demo",
    )

def ui_tests(
):
    ios_ui_test(
        name = "PlayerUI-UI-ViewInspectorTests",
        module_name = "PlayerUI_UI_ViewInspectorTests",
        swift_version = "5.1",
        xcconfig = {
            "ENABLE_BITCODE": "NO",
            "ENABLE_TESTING_SEARCH_PATHS": "YES",
            "PRODUCT_BUNDLE_IDENTIFIER": "com.intuit.ios.PlayerUI-ExampleUITests",
            "CODE_SIGN_STYLE": "Manual",
            "CODE_SIGN_IDENTITY[sdk=iphoneos*]": "iPhone Developer",
            "PROVISIONING_PROFILE_SPECIFIER": "match Development com.intuit.ios.PlayerUI-ExampleUITests*",
            "DEVELOPMENT_TEAM": "F6DWWXWEX6",
        },
        srcs = glob([
            "ios/ViewInspector/**/*.h",
            "ios/ViewInspector/**/*.hh",
            "ios/ViewInspector/**/*.m",
            "ios/ViewInspector/**/*.mm",
            "ios/ViewInspector/**/*.swift",
            "ios/ViewInspector/**/*.c",
            "ios/ViewInspector/**/*.cc",
            "ios/ViewInspector/**/*.cpp",
            "ios/packages/demo/Sources/MockFlows.swift",
        ]),
        deps = [
            ":PlayerUI",
            "@Pods//ViewInspector",
        ],
        bundle_id = "com.intuit.ios.PlayerUI-ExampleUITests",
        minimum_os_version = "14.0",
        test_host = ":PlayerUI-Demo",
    )
    ios_ui_test(
        name = "PlayerUI-UI-XCUITests",
        module_name = "PlayerUI_UI_XCUITests",
        swift_version = "5.1",
        xcconfig = {
            "ENABLE_BITCODE": "NO",
            "ENABLE_TESTING_SEARCH_PATHS": "YES",
            "PRODUCT_BUNDLE_IDENTIFIER": "com.intuit.ios.PlayerUI-ExampleUITests",
            "CODE_SIGN_STYLE": "Manual",
            "CODE_SIGN_IDENTITY[sdk=iphoneos*]": "iPhone Developer",
            "PROVISIONING_PROFILE_SPECIFIER": "match Development com.intuit.ios.PlayerUI-ExampleUITests*",
            "DEVELOPMENT_TEAM": "F6DWWXWEX6",
        },
        srcs = glob([
            "ios/XCUI/**/*.h",
            "ios/XCUI/**/*.hh",
            "ios/XCUI/**/*.m",
            "ios/XCUI/**/*.mm",
            "ios/XCUI/**/*.swift",
            "ios/XCUI/**/*.c",
            "ios/XCUI/**/*.cc",
            "ios/XCUI/**/*.cpp",
        ]),
        deps = [
            ":PlayerUI",
            "@Pods//EyesXCUI",
        ],
        bundle_id = "com.intuit.ios.PlayerUI-ExampleUITests",
        minimum_os_version = "14.0",
        test_host = ":PlayerUI-Demo",
    )
