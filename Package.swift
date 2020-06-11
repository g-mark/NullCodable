// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NullCodable",
    products: [
        .library(
            name: "NullCodable",
            targets: ["NullCodable"]),
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "NullCodable",
            dependencies: []),
        .testTarget(
            name: "NullCodableTests",
            dependencies: ["NullCodable"]),
    ]
)
