@testable import Core
import XCTest

final class TryResultTests: XCTestCase {
    func testResultForTryAndWord() throws {
        XCTAssertEqual(
            [.wrongPosition, .correct, .wrong, .wrong, .wrong],
            result(for: "parry", word: "lapse")
        )

        XCTAssertEqual(
            [.correct, .correct, .correct, .correct, .correct],
            result(for: "sweet", word: "sweet")
        )
        
        XCTAssertEqual(
            [.wrongPosition, .wrongPosition, .correct, .wrongPosition, .wrongPosition],
            result(for: "teews", word: "sweet")
        )
        
        XCTAssertEqual(
            [.correct, .correct, .correct, .correct, .correct],
            result(for: "aaaaa", word: "aaaaa")
        )
        
        XCTAssertEqual(
            [.wrong, .wrong, .wrong, .wrong, .wrong],
            result(for: "aaaaa", word: "bbbbb")
        )
    }
}
