
import Foundation

public struct DuWrapper<Base> {
    let base: Base
    init(base: Base) {
        self.base = base
    }
}

public protocol LSCompatible {
    associatedtype WrappableType
    var du: WrappableType { get }
    static var du: WrappableType.Type { get }
}

public extension LSCompatible {
    
    var du: DuWrapper<Self> {
        return DuWrapper(base: self)
    }
    
    static var du: DuWrapper<Self>.Type {
        return DuWrapper.self
    }
}

extension URL: LSCompatible {}
extension String: LSCompatible {}
extension NSObject: LSCompatible { }

