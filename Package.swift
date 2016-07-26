import PackageDescription

let package = Package(
    name: "Yopuy",
    depdendencies: [
        .Package(url: "https://github.com/johnsundell/unbox.git", majorVersion: 1)
    ]
)
