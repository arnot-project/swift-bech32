// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Bech32",
    products: [
        .library(
            name: "Bech32",
            targets: ["Bech32"]),
    ],
    targets: [
        .target(
            name: "Bech32",
            dependencies: []),
        .testTarget(
            name: "Bech32Tests",
            dependencies: ["Bech32"]),
    ]
)
