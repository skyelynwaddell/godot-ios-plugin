// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "godot_ios_plugin",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "godot_ios_plugin",
            type: .dynamic,
            targets: ["godot_ios_plugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/migueldeicaza/SwiftGodot", branch: "main"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "godot_ios_plugin",
            dependencies: [
              "SwiftGodot",
              .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
              .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
              .product(name: "FirebaseInstallations", package: "firebase-ios-sdk"),
              .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
              .product(name: "FirebaseCore", package: "firebase-ios-sdk"),
            ],
            //resources: [
            //    .copy("Firebase_FirebaseMessaging.bundle")
            //],
            swiftSettings: [.unsafeFlags(["-suppress-warnings"])],
            linkerSettings: [
                .linkedFramework("GameKit"),
                .linkedFramework("StoreKit")
            ]
        ),
    ]
)
