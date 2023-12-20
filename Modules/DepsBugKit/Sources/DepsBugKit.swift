import Foundation
import Dependencies

public struct Command<T> {
    
    public var action: () -> T
    
    public init(_ action: @escaping () -> T) {
        self.action = action
    }
}

public extension Command {
    
    var withEscapedDependencies_inFramework: Command {
        Dependencies.withEscapedDependencies { [action] deps in
            Command {
                deps.yield(action)
            }
        }
    }
}
