import XCTest
@testable import RSTree

final class RSTreeTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(RSTree().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
