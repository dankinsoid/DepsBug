import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
	swiftPackageManager: SwiftPackageManagerDependencies(
		[
            .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.1.0"),
		]
	),
	platforms: [.iOS]
)
