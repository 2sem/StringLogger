// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StringLogger",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "StringLogger",
            targets: ["StringLogger"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "StringLogger",
            // Sources live in Sources/Extensions, not the conventional
            // Sources/StringLogger. SwiftPM falls back to Sources/ for a lone
            // target, but Tuist's SPM integration doesn't, so say it explicitly.
            path: "Sources"),
        .testTarget(
            name: "StringLoggerTests",
            dependencies: ["StringLogger"]),
    ]
)
