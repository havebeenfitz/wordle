@testable import Core
import XCTest

final class TryResultTests: XCTestCase {
    func testResultForTryAndWord() throws {
        XCTAssertEqual(
            [.wrongPosition, .correct, .wrong, .wrong, .wrong],
            result(for: "parry", word: "lapse")
        )
    }
}
