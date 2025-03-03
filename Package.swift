// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GridKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "GridKit",
            type: .dynamic,
            targets: ["GridKit"]),
    ],
    targets: [
        .binaryTarget(
            name: "GridKit",
            url: "https://github.com/Devansh-Seth-DEV/GridKit/releases/download/v1.0.0/GridKit.xcframework.zip",
            checksum: "64f996064e9041ddb87ac6c5396db6a2ce158c0aa38aab0643459c362e2e633b"
        ),
    ]
)
