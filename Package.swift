// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Neon",
    dependencies: [
        .package(url: "https://github.com/Zewo/CZeroMQ.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-protobuf", from: "1.0.0"),
        .package(url: "https://github.com/kylef/Commander.git", from: "0.0.0"),
        .package(url: "https://github.com/andybest/linenoise-swift.git", from: "0.0.0")
    ],
    targets: [
        .target(name: "Neon", dependencies: [
            "SwiftProtobuf", "Commander", "LineNoise"
        ])
    ]
)
