import Core
import UIKit

public class ScoreCell: UICollectionViewCell {
    var viewModel: ScoreViewModel?

    override public func updateConfiguration(using state: UICellConfigurationState) {
        guard let viewModel else { return }
        
        var content = ScoreContentConfiguration(viewModel: viewModel).updated(for: state)
        content.viewModel.isSelected = state.isSelected
        contentConfiguration = content
    }
}

private struct ScoreContentConfiguration: UIContentConfiguration, Hashable {
    var viewModel: ScoreViewModel

    init(viewModel: ScoreViewModel) {
        self.viewModel = viewModel
    }

    func makeContentView() -> UIView & UIContentView {
        ScoreContentView(configuration: self)
    }

    func updated(for _: UIConfigurationState) -> Self { self }
}

private class ScoreContentView: UIView, UIContentView {
    private var _configuration: ScoreContentConfiguration
    var configuration: UIContentConfiguration {
        get { _configuration }
        set {
            guard let config = newValue as? ScoreContentConfiguration,
                  _configuration != config
            else { return }
            _configuration = config
            apply(configuration: config)
        }
    }

    private lazy var stackView: UIStackView = makeStackView()
    private lazy var dateLabel: UILabel = makeDateLabel()
    private lazy var statLabel: UILabel = makeDateLabel()

    init(configuration: ScoreContentConfiguration) {
        _configuration = configuration
        super.init(frame: .zero)
        addConstrainedSubview(
            stackView,
            insets: .init(top: 8, left: 16, bottom: 8, right: 16),
            edges: .all
        )
        apply(configuration: configuration)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func apply(configuration: ScoreContentConfiguration) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let viewModel = configuration.viewModel
        dateLabel.text = viewModel.date
        statLabel.text = viewModel.statText
        
        stackView.addArrangedSubview(statLabel)
        stackView.addArrangedSubview(dateLabel)
        viewModel.tries.forEach {
            let row = makeRowView(from: $0, isSelected: viewModel.isSelected)
            stackView.addArrangedSubview(row)
        }

        setNeedsLayout()
    }

    private func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .leading
        return view
    }
    
    private func makeStatsLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingMiddle
        view.allowsDefaultTighteningForTruncation = true
        view.adjustsFontForContentSizeCategory = true
        view.font = UIFont.preferredFont(forTextStyle: .title1)
        view.textColor = .label
        return view
    }

    private func makeDateLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingMiddle
        view.allowsDefaultTighteningForTruncation = true
        view.adjustsFontForContentSizeCategory = true
        view.font = UIFont.preferredFont(forTextStyle: .caption2)
        view.textColor = .label
        return view
    }
    
    private func makeRowView(from try: TriesCollection.Element, isSelected: Bool) -> WordRowView {
        let word = `try`.key.word
        let results = `try`.value
        
        return WordRowView(isSelected: isSelected, word: word, results: results)
    }
}

private final class WordRowView: UIView {
    private let letterViews: [LetterView]
    private lazy var stackView: UIStackView = makeStackView()

    init(isSelected: Bool, word: String, results: [LetterResult]) {
        precondition(word.utf8.count == 5)
        precondition(results.count <= 5)
        
        letterViews = word.enumerated().map {
            LetterView(letter: String($0.element), result: results[$0.offset], isVisible: isSelected)
        }
        
        super.init(frame: .zero)
        
        addConstrainedSubview(stackView)
        setUpContraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeStackView() -> UIStackView {
        let view = UIStackView(arrangedSubviews: letterViews)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.axis = .horizontal
        view.spacing = 2
        view.alignment = .center
        view.distribution = .fillEqually
        return view
    }

    private func setUpContraints() {
        let first = letterViews[0]
        let constraints = letterViews.dropFirst().flatMap { lv in
            let w = lv.widthAnchor.constraint(equalTo: first.widthAnchor)
            let h = lv.heightAnchor.constraint(equalTo: lv.widthAnchor)
            return [w, h]
        }
        NSLayoutConstraint.activate(constraints)
    }
}

private final class LetterView: UIView {
    private let letter: String
    private let result: LetterResult
    private let isVisible: Bool
    
    private lazy var label: UILabel = makeLabel()

    init(letter: String, result: LetterResult, isVisible: Bool) {
        precondition(letter.utf8.count == 1)
        
        self.letter = letter
        self.result = result
        self.isVisible = isVisible
        
        super.init(frame: .zero)
        
        setupUI()
        addConstrainedSubview(label)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        label.isHidden = !isVisible
        backgroundColor = color(for: result)
    }

    private func makeLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.numberOfLines = 1
        view.allowsDefaultTighteningForTruncation = false
        view.adjustsFontForContentSizeCategory = true
        view.textAlignment = .center
        view.textColor = .label
        view.text = letter
        return view
    }
    
    private func color(for result: LetterResult) -> UIColor {
        switch result {
        case .correct:
            return .systemGreen
        case .wrongPosition:
            return .systemYellow
        case .wrong:
            return .systemFill
        }
    }
}

#if DEBUG

    import SwiftUI

    struct ScoreCellView_Preview: PreviewProvider {
        static var previews: some View {
            CellView().previewLayout(.fixed(width: 300, height: 150))
        }
    }

    private struct CellView: UIViewRepresentable {
        func makeUIView(context _: Context) -> ScoreContentView {
            ScoreContentView(configuration: .init(viewModel: .init(
                id: 1,
                date: "2022/03/05",
                tries: [
                    .init(word: "corgi"): [.wrong, .wrong, .wrongPosition, .wrong, .wrong],
                    .init(word: "corge"): [.correct, .correct, .wrongPosition, .wrong, .correct],
                    .init(word: "pause"): [.correct, .correct, .wrongPosition, .wrong, .correct],
                    .init(word: "sleds"): [.wrongPosition, .correct, .wrongPosition, .wrong, .correct],
                    .init(word: "sweet"): [.correct, .correct, .correct, .correct, .correct]
                ]
            )))
        }

        func updateUIView(_: ScoreContentView, context _: Context) {}
    }
#endif
