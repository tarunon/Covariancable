# Covariancable
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

Add covariance/contravariance feature on your type-erasure.

## Summary 
```swift
let catCage = MyCatCage()
let typeErasedCatCage = AnyAnimalCage<Cat>(catCage) // It's ok 😊
let typeErasedAnimalCageA = AnyAnimalCage<Animal>(catCage) // Cannot compile it. 🤕
let typeErasedAnimalCage = AnyAnimalCage<Animal>(animal: catCage.animal, otherproperties....) // Usually, compile ok but too annoying. 🤔 
let convarianceAnimalCage = AnyAnimalCage<Animal>(~catCage) // Adding `~` operator, pass compile it! 💪
```

## How to use
1. Conform `Covariancable` at your protocol, or implement `Covariancable` on every concrete type.
```swift
protocol MyCustomProtocol: Covariancable {
  associatedtype MyGenericsType
  var myParameter: MyGenericsType { get }
  var foo: Int { get }
  var bar: String { get }

  associatedtype PropertiesType = Properties<(myParameter: MyGenericsType, foo: Int, bar: String)>
}

extension MyCustomProtocol where PropertiesType == Properties<(myParameter: MyGenericsType, foo: Int, bar: String)> {
  var properties: PropertiesType = PropertiesType {
    return Properties((myParameter: myParameter, foo: foo, bar: bar))
  }
}
```

2. Extend your type-erasure using `CovarianceTypeErasureProtocol`.
```swift
extension AnyMyCustomProtocol: CovarianceTypeErasureProtocol {
  init(_ properties: PropertiesType) {
    self.init(myParameter: properties.value.myParameter, foo: properties.value.foo, bar: properties.value.bar)
  }
}
```

3. Try out!
```swift
let _ =  AnyMyCustomProtocol<UIView>(~someSpecificViewsImpl)
```

## Installation
### Carthage
```ruby
github "tarunon/Covariancable"
```

### Swift Package Manager
```swift
.Package(url: "https://github.com/tarunon/Covariancable.git", Version(0, 1, 0))
```

## LICENSE
MIT
