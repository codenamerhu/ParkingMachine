import Foundation
import XCTest

// coins 5c(1/2), 10c(1), 20c(20), 50c(50), R 1(100), R 2(200), and R 5(500) denominations.
// Banknotes include R 10(1000), R 20((2000), R 50(5000), R 100(10000), R200(20000) denominations.

enum isRandDemonimation: Double {
    // MARK: COINS
    case fivecents = 0.05
    case tencents = 0.10
    case twentycents = 0.20
    case fiftycents = 0.50
    case onerand = 1
    case fiverands = 5
    
    //MARK: BANKNOTES
    case tenrands = 10
    case twentyrands = 20
    case fiftyrands = 50
    case onehundredrands = 100
    case twohundredrands = 200
}

enum RandDenominationError: Error {
    case notEnoughFunds
}

// MARK:- MAIN FUNCTION
// PARAMETER 1 as amountPaying
// PARAMETER 2 as amountToDeduct
func pay(amountPaying: Double, amountToDeduct: Double) ->  String {
    
    let change = amountPaying - amountToDeduct
    
    if amountPaying < amountToDeduct {
        print("\(RandDenominationError.notEnoughFunds) : R\(abs(change)) remaining balance")
        return "\(RandDenominationError.notEnoughFunds)"
    }
    print("""
        amount put into the machine R\(amountPaying)\n
        __
        amount to be deducted R\(amountToDeduct)\n
        \n
        """)
    
    let randCollection = [isRandDemonimation.twohundredrands.rawValue,
                        isRandDemonimation.onehundredrands.rawValue,
                        isRandDemonimation.fiftyrands.rawValue,
                        isRandDemonimation.twentyrands.rawValue,
                        isRandDemonimation.tenrands.rawValue,
                        isRandDemonimation.fiverands.rawValue,
                        isRandDemonimation.onerand.rawValue]
    
    let centsCollection = [isRandDemonimation.fiftycents.rawValue,
                           isRandDemonimation.twentycents.rawValue,
                           isRandDemonimation.tencents.rawValue,
                           isRandDemonimation.fivecents.rawValue]
    
    
    
    var integerChange = Int(change - change.truncatingRemainder(dividingBy: 1))
    
    var forCents = Int(change.truncatingRemainder(dividingBy: 1) * 100)
    
    print("Notes/Coins | Quantity")
    print("____________|_________")
    for x in randCollection {
        let chageQuantity = getQuantity(change: integerChange, totalCentsInChange: Int(x))
        integerChange = changeLeft(change: integerChange, totalCentsInChange: Int(x))
        
        var space = ""
        if (x) <= 9 { space = "          " }
        else if ((x) > 9 && (x) <= 99) { space = "         " }
        else if ((x ) > 99) { space = "        " }
        
        if chageQuantity  != 0 { print("R\(Int(x))\(space)| \(chageQuantity)") }
    }
    
    for y in centsCollection {
        let changeQuantity = getQuantity(change: forCents, totalCentsInChange: Int(y * 100))
        forCents = changeLeft(change: forCents, totalCentsInChange: Int(y * 100))

        var space = ""
        if (y * 100) <= 9.0 { space = "          " }
        else if ((y * 100) >= 10.0 && (y * 100) <= 99.0) { space = "         " }
        else if (y * 100 > 99.0) { space = "         " }

        if changeQuantity != 0 { print("\(Int(y * 100))c\(space)| \(changeQuantity)") }
    }

    print("____________|_________")
    var cents = ""
    if change.truncatingRemainder(dividingBy: 1) * 100 <= 9.0 {
        cents = "0\(Int(change.truncatingRemainder(dividingBy: 1) * 100))"
    } else {
        cents = "\(Int(change.truncatingRemainder(dividingBy: 1) * 100))"
    }
    
    print("\nTotal in change : R\(Int(change - change.truncatingRemainder(dividingBy: 1))).\(cents)")
    return "\(Int(change - change.truncatingRemainder(dividingBy: 1))).\(cents)"
}

//
func getQuantity(change: Int, totalCentsInChange: Int) -> Int {
    return change / totalCentsInChange
}

//
func changeLeft(change: Int, totalCentsInChange: Int) -> Int{
    return change % totalCentsInChange
}

print(pay(amountPaying: 90.90, amountToDeduct: 24))


class ParkingMachineTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testMainfunctionsIntegrity(){
        XCTAssertEqual(pay(amountPaying: 65.25, amountToDeduct: 50), "15.25")
        XCTAssertEqual(pay(amountPaying: 65.15, amountToDeduct: 50), "15.15")
        XCTAssertEqual(pay(amountPaying: 50.00, amountToDeduct: 10), "40.00")
        
        XCTAssertEqual(pay(amountPaying: 10, amountToDeduct: 50), "\(RandDenominationError.notEnoughFunds)")
    }
    
    func testGetQuantity() {
        XCTAssertEqual(getQuantity(change: 50, totalCentsInChange: 10), 5)
        XCTAssertEqual(getQuantity(change: 10, totalCentsInChange: 10), 1)
        XCTAssertEqual(getQuantity(change: 10, totalCentsInChange: 50), 0)
        
    }
    
}

//class TestObserver: NSObject, XCTestObservation {
//    private func testCase(_ testCase: XCTestCase,
//                  didFailWithDescription description: String,
//                  inFile filePath: String?,
//                  atLine lineNumber: UInt) {
//        assertionFailure(description, line: lineNumber)
//    }
//}
//
//fileprivate let testObserver = TestObserver()
//XCTestObservationCenter.shared().addTestObserver(testObserver)

ParkingMachineTests.defaultTestSuite.run()
