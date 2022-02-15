// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "RSTree",
    products: [
        .library(
            name: "RSTree",
            type: .dynamic,
            targets: ["RSTree"]),
    ],
    // dependencies = [
    //     .package(url: "https://github.com/apple/swift-docc-plugin", branch: "main"),
    // ]
    targets: [
        .target(
            name: "RSTree",
            dependencies: []),
    ]
)
