// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SeebaroUI",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SeebaroUI",
            targets: ["SeebaroUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kean/Nuke", from: "12.8.0"),
    ],
    targets: [
        .target(
            name: "SeebaroUI",
            dependencies: [
                .product(name: "Nuke", package: "Nuke"),
                .product(name: "NukeUI", package: "Nuke"),
            ]
        ),
    ]
)
