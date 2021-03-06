// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "CodableKit",
    products: [
        .library(name: "CodableKit", targets: ["CodableKit"]),
    ],
    targets: [
        .target(name: "CodableKit"),
        .testTarget(name: "CodableKitTests", dependencies: ["CodableKit"]),
    ]
)
