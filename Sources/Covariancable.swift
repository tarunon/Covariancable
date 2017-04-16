public protocol Covariancable {
    associatedtype PropertiesType: PropertiesProtocol
    
    var properties: PropertiesType { get }
}

public protocol CovarianceTypeErasureProtocol: Covariancable {
    init(_ properties: PropertiesType)
}

public extension CovarianceTypeErasureProtocol {
    public init(_ builder: PropertiesType.Builder) {
        self.init(PropertiesType(builder))
    }
}

prefix operator ~

public prefix func ~<C: Covariancable>(_ argument: C) -> C.PropertiesType.Builder {
    return argument.properties.builder
}

public protocol PropertiesProtocol {
    associatedtype T
    var value: T { get }
    
    init(_ value: T)
}

extension PropertiesProtocol {
    public typealias Builder = () -> T
    
    internal func builder() -> T {
        return value
    }
    
    internal init(_ builder: Builder) {
        self.init(builder())
    }
}

struct Properties<T>: PropertiesProtocol {
    var value: T

    init(_ value: T) {
        self.value = value
    }
}
