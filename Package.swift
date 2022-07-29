// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Scrollometer",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Scrollometer",
            targets: ["Scrollometer"]),
    ],
    targets: [
        .target(
            name: "Scrollometer",
            dependencies: [],
            path: "Source"),
    ],
    swiftLanguageVersions: [.v5]
)
