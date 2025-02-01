import Foundation
import Dependencies
import DepsBug
import DepsBugKit
import XCTest

final class DepsBugTests: XCTestCase {

    func test_escaped_dependencies() async throws {
        let currentValue = Dependency(\.areDependenciesLost).wrappedValue

        let command1 = withDependencies {
            $0.areDependenciesLost = false
        } operation: {
            Command {
                Dependency(\.areDependenciesLost).wrappedValue
            }
            .withEscapedDependencies_inTests
        }

        let command2 = withDependencies {
            $0.areDependenciesLost = false
        } operation: {
            Command {
                Dependency(\.areDependenciesLost).wrappedValue
            }
            .withEscapedDependencies_inFramework
        }
        
        let command3 = withDependencies {
            $0.areDependenciesLost = false
        } operation: {
            Command {
                Dependency(\.areDependenciesLost).wrappedValue
            }
            .withEscapedDependencies_inApp
        }
        
        print(test_escaped_dependencies_in_app())
        
        XCTAssertEqual(currentValue, true)
        XCTAssertEqual(command1.action(), false)
        XCTAssertEqual(command2.action(), false)
    }
}

public extension Command {
    
    var withEscapedDependencies_inTests: Command {
        Dependencies.withEscapedDependencies { [action] deps in
            Command {
                deps.yield(action)
            }
        }
    }
}
