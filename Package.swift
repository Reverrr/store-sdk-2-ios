// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorStorekit2Ios",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "CapacitorStorekit2Ios",
            targets: ["StoreKit2iOSPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "StoreKit2iOSPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/StoreKit2iOSPlugin"),
        .testTarget(
            name: "StoreKit2iOSPluginTests",
            dependencies: ["StoreKit2iOSPlugin"],
            path: "ios/Tests/StoreKit2iOSPluginTests")
    ]
)