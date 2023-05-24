import Foundation
import OrderedCollections
import Core

typealias TriesCollection = OrderedDictionary<ScoreViewModel.Try, [LetterResult]>

extension OrderedDictionary where Key == ScoreViewModel.Try, Value == [LetterResult] {
    init(_ keys: [Key], finalWord: String) {
        self.init(uniqueKeysWithValues: keys.map { ($0, result(for: $0.word, word: finalWord)) })
    }
}
