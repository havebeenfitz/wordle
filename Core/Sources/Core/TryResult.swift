import Foundation

public enum LetterResult {
    case correct
    case wrongPosition
    case wrong
}

/// Algorithm for correct letter calculation
/// O(n) complexity for each word
public func result(for try: String, word: String) -> [LetterResult] {
    let wordMap: [String: Set<Int>] = word.enumerated().reduce(into: [:]) { partialResult, value in
        let stringElement = String(value.element)
        var newValue = partialResult[stringElement] ?? Set()
        newValue.insert(value.offset)
        
        partialResult[stringElement] = newValue
    }
    
    return `try`.enumerated().map { value in
        let stringValue = String(value.element)
        let index = value.offset
        
        if wordMap[stringValue]?.contains(index) == true {
            return .correct
        }
        
        if wordMap[stringValue]?.isEmpty == false {
            return .wrongPosition
        }
        
        return .wrong
    }
}
