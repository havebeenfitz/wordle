import OrderedCollections
import UIKit
import Core

struct ScoreViewModel: Identifiable, Hashable {
    var isSelected: Bool = false
    
    let id: Int
    let date: String
    let tries: TriesCollection
    
    var statText: String {
        let didWin = tries.values.last?.allSatisfy { $0 == .correct } ?? false
        
        let countText = didWin ? "\(tries.count)/6" : "lost"
        return "Wordle \(id) \(countText)"
    }
}

extension ScoreViewModel {
    
    struct Try: Hashable {
        let id = UUID()
        let word: String
    }
}

// MARK: - Mappings

extension Score {
    
    var asViewModel: ScoreViewModel {
        let tries = tries.map { ScoreViewModel.Try(word: $0) }

        return ScoreViewModel(
            id: id,
            date: date.stringValue,
            tries: TriesCollection(tries, finalWord: word)
        )
    }
}
