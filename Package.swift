// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PersistenceKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "PersistenceKit", targets: ["PersistenceKit"]),
    ],
    dependencies: [
        .package(path: "../DomainKit"),
    ],
    targets: [
        .target(
            name: "PersistenceKit",
            dependencies: ["DomainKit"],
            path: "Sources/PersistenceKit",
            linkerSettings: [
                .linkedFramework("CoreData"),
            ]
        ),
        .testTarget(
            name: "PersistenceKitTests",
            dependencies: ["PersistenceKit", "DomainKit"],
            path: "Tests/PersistenceKitTests"
        ),
    ]
)
