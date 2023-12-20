import UIKit
import Dependencies
import DepsBugKit
import DepsBugUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        test_escaped_dependencies_in_app()
        return true
    }
    
}

public extension DependencyValues {
    
    var areDependenciesLost: Bool {
        get {
            self[AreDependenciesLostKey.self]
        }
        set {
            self[AreDependenciesLostKey.self] = newValue
        }
    }
}

private extension DependencyValues {
    
    enum AreDependenciesLostKey: DependencyKey {
        
        static let liveValue = true
        static let testValue = true
    }
}

public extension Command {
    
    var withEscapedDependencies_inApp: Command {
        Dependencies.withEscapedDependencies { [action] deps in
            Command {
                deps.yield(action)
            }
        }
    }
}

public func test_escaped_dependencies_in_app() {
    let currentValue = Dependency(\.areDependenciesLost).wrappedValue
    
    let command1 = withDependencies {
        $0.areDependenciesLost = false
    } operation: {
        Command {
            print(Dependency(\.areDependenciesLost).wrappedValue)
        }
        .withEscapedDependencies_inFramework
    }
    
    let command2 = withDependencies {
        $0.areDependenciesLost = false
    } operation: {
        Command {
            print(Dependency(\.areDependenciesLost).wrappedValue)
        }
        .withEscapedDependencies_inApp
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        command1.action()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            command2.action()
        }
    }
}
