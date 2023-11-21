// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let pluginList: [String] = ["BaseBeaconPlugin", "CommonTypesPlugin", "ExpressionPlugin"]
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
                "plugins/BeaconPlugin"
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
                .target(name: "PlayerUIBeaconPlugin")
            ],
            path: "ios/Sources/reference-assets",
            resources: [
                .process("Resources")
            ]
        ),

        .target(
            name: "PlayerUIBeaconPlugin",
            dependencies: [
                .target(name: "PlayerUI"),
                .target(name: "PlayerUIBaseBeaconPlugin")
            ],
            path: "ios/Sources/plugins/BeaconPlugin"
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
