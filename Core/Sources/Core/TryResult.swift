import Foundation

public enum LetterResult {
    case correct
    case wrongPosition
    case wrong
}

public func result(for try: String, word _: String) -> [LetterResult] {
    `try`.map { _ in .wrong }
}
