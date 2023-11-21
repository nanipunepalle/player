// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// Simple plugins that just rely on core + their own JS bundle
let pluginList: [String] = [
    "BaseBeaconPlugin",
    "CheckPathPlugin",
    "CommonExpressionsPlugin",
    "CommonTypesPlugin", 
    "ComputedPropertiesPlugin",
    "ExpressionPlugin",
    "ExternalActionPlugin",
    "MetricsPlugin",
    "PubSubPlugin",
    "StageRevertDataPlugin",
    "TypesProviderPlugin"
]

let plugins: [(Target, Product)] = pluginList.map { (Target.playerPlugin(name: $0), Product.playerPlugin(name: $0)) }

let package = Package(
    name: "PlayerUI",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "PlayerUI",
            targets: ["PlayerUI"]
        ),
        .library(
            name: "PlayerUIReferenceAssets",
            targets: ["PlayerUIReferenceAssets"]
        ),
        .library(
            name: "PlayerUIBeaconPlugin",
            targets: ["PlayerUIBeaconPlugin"]
        ),
        .library(
            name: "PlayerUISwiftUICheckPathPlugin",
            targets: ["PlayerUISwiftUICheckPathPlugin"]
        ),
        .library(
            name: "PlayerUISwiftUIPendingTransactionPlugin",
            targets: ["PlayerUISwiftUIPendingTransactionPlugin"]
        ),
        .library(
            name: "PlayerUITransitionPlugin",
            targets: ["PlayerUITransitionPlugin"]
        )
    ] + plugins.map(\.1),
    dependencies: [
        // Tools
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", .upToNextMajor(from: "2.29.0")),

        .package(url: "https://github.com/intuit/swift-hooks.git", .upToNextMajor(from: "0.1.0")),

        // Testing
        // .package(url: "https://github.com/applitools/eyes-xcui-swift-package.git", .upToNextMajor(from: "8.9.1")),
        // .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", .upToNextMajor(from: "1.9.0")),
        // .package(url: "https://github.com/mattgallagher/CwlPreconditionTesting.git", .upToNextMajor(from: "2.1.2")),
        // .package(url: "https://github.com/nalexn/ViewInspector", .upToNextMajor(from: "0.9.1"))
    ],
    targets: [
        // Packages
        .target(
            name: "PlayerUI",
            dependencies: [
                .product(name: "SwiftHooks", package: "swift-hooks"),
                .target(name: "PlayerUILogger")
            ],
            path: "ios/Sources",
            exclude: [
                "reference-assets",
                "logger",
                "plugins/BeaconPlugin",
                "plugins/SwiftUICheckPathPlugin",
                "plugins/ExternalActionViewModifierPlugin",
                "plugins/SwiftUIPendingTransactionPlugin",
                "plugins/TransitionPlugin"
            ] + pluginList.map { "plugins/\($0)" },
            resources: [
                .process("core/Resources")
            ]
        ),
        .target(
            name: "PlayerUILogger",
            dependencies: [
                .product(name: "SwiftHooks", package: "swift-hooks"),
            ],
            path: "ios/Sources/logger"
        ),
        .target(
            name: "PlayerUIReferenceAssets",
            dependencies: [
                .product(name: "SwiftHooks", package: "swift-hooks"),
                .target(name: "PlayerUI"),
                .target(name: "PlayerUIBeaconPlugin"),
                .target(name: "PlayerUISwiftUIPendingTransactionPlugin")
            ],
            path: "ios/Sources/reference-assets",
            resources: [
                .process("Resources")
            ]
        ),

        // Plugins with dependencies
        .target(
            name: "PlayerUIBeaconPlugin",
            dependencies: [
                .target(name: "PlayerUI"),
                .target(name: "PlayerUIBaseBeaconPlugin")
            ],
            path: "ios/Sources/plugins/BeaconPlugin"
        ),
        .target(
            name: "PlayerUISwiftUICheckPathPlugin",
            dependencies: [
                .target(name: "PlayerUI"),
                .target(name: "PlayerUICheckPathPlugin")
            ],
            path: "ios/Sources/plugins/SwiftUICheckPathPlugin"
        ),
        .target(
            name: "PlayerUISwiftUIPendingTransactionPlugin",
            dependencies: [
                .target(name: "PlayerUI")
            ],
            path: "ios/Sources/plugins/SwiftUIPendingTransactionPlugin"
        ),
        .target(
            name: "PlayerUITransitionPlugin",
            dependencies: [
                .target(name: "PlayerUI")
            ],
            path: "ios/Sources/plugins/TransitionPlugin"
        )
    ] + plugins.map(\.0)
)


extension Product {
    static func playerPlugin(name: String) -> Product {
        .library(name: "PlayerUI\(name)", targets: ["PlayerUI\(name)"])
    }
}
extension Target {
    static func playerPlugin(name: String) -> Target {
        .target(
            name: "PlayerUI\(name)",
            dependencies: [
                .target(name: "PlayerUI")
            ],
            path: "ios/Sources/plugins/\(name)",
            resources: [
                .process("Resources")
            ]
        )
    }
}
