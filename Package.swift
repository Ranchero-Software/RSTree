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
    targets: [
        .target(
            name: "RSTree",
            dependencies: []),
    ]
)
