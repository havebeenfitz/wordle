import Core
import UIKit

public class ScoreCell: UICollectionViewCell {
    var score: Score?

    override public func updateConfiguration(using state: UICellConfigurationState) {
        contentConfiguration = ScoreContentConfiguration(score: score)
            .updated(for: state)
    }
}

private struct ScoreContentConfiguration: UIContentConfiguration, Hashable {
    var date: String
    var tries: [String]
    var word: String

    init(score: Score? = nil) {
        guard let score else {
            date = ""
            tries = []
            word = ""
            return
        }
        date = score.date.stringValue
        tries = score.tries
        word = score.word
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
    private var rowViews: [WordRowView] = []

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
        rowViews.forEach { $0.removeFromSuperview() }
        rowViews.removeAll()

        dateLabel.text = configuration.date
        configuration.tries.forEach { word in
            let row = WordRowView(word: word)
            stackView.addArrangedSubview(row)
        }

        setNeedsLayout()
    }

    private func makeStackView() -> UIStackView {
        let view = UIStackView(arrangedSubviews: [dateLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .leading
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
}

private final class WordRowView: UIView {
    private var word: String
    private let letterViews: [LetterView]
    private lazy var stackView: UIStackView = makeStackView()

    init(word: String) {
        precondition(word.utf8.count == 5)
        self.word = word
        letterViews = word.map { LetterView(letter: String($0)) }
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
    private var letter: String
    private lazy var label: UILabel = makeLabel()

    init(letter: String) {
        precondition(letter.utf8.count == 1)
        self.letter = letter
        super.init(frame: .zero)
        addConstrainedSubview(label)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        view.backgroundColor = .systemFill
        view.text = letter
        return view
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
            ScoreContentView(configuration: .init(score: .init(
                id: 1,
                date: .init(year: 2022, month: 3, day: 27),
                word: "nymph",
                tries: ["train", "ponds", "blume", "nymph"]
            )))
        }

        func updateUIView(_: ScoreContentView, context _: Context) {}
    }
#endif
