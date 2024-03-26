// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "FitAnalyticsWebWidget",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "FitAnalyticsWebWidget",
            targets: ["FitAnalyticsWebWidget"]
        )
    ],
    targets: [
        .target(
            name: "FitAnalyticsWebWidget",
            path: "FitAnalytics-WebWidget",
            resources: [.copy("PrivacyInfo.xcprivacy")],
            publicHeadersPath: "./"
        )
    ]
)
