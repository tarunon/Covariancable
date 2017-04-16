import XCTest
@testable import Covariancable

class Animal: NSObject {}
class Cat: Animal {}
class Dog: Animal {}

protocol AnimalCage: Covariancable {
    associatedtype AnimalType: Animal
    
    var animal: AnimalType { get }
    var area: CGRect { get }
    
    associatedtype PropertiesType = Properties<(animal: AnimalType, area: CGRect)>
}

extension AnimalCage where PropertiesType == Properties<(animal: AnimalType, area: CGRect)> {
    var properties: Properties<(animal: AnimalType, area: CGRect)> {
        return Properties((animal: animal, area: area))
    }
}

struct AnyAnimalCage<A: Animal>: AnimalCage {
    var animal: A
    var area: CGRect
}

extension AnyAnimalCage: CovarianceTypeErasureProtocol {
    init<C: AnimalCage>(_ cage: C) where C.AnimalType == A {
        self.init(animal: cage.animal, area: cage.area)
    }
    
    init(_ properties: PropertiesType) {
        self.init(animal: properties.value.animal, area: properties.value.area)
    }
}

class CovariancableTests: XCTestCase {
    func testAbleToCompile() {
        let catCage = AnyAnimalCage<Cat>(animal: Cat(), area: CGRect.zero)
        let animalCage = AnyAnimalCage<Animal>(~catCage)
        XCTAssertEqual(catCage.animal, animalCage.animal)
        XCTAssertEqual(catCage.area, animalCage.area)
    }
    
    func testNotAbleToCompile() {
        // TODO: check cannot comiple it calling swift build command on shell.
        let catCage = AnyAnimalCage<Cat>(animal: Cat(), area: CGRect.zero)
//        let dogCage = AnyAnimalCage<Dog>(~catCage)
    }


    static var allTests = [
        ("testAbleToCompile", testAbleToCompile),
        ("testNotAbleToCompile", testNotAbleToCompile),
    ]
}
