import UIKit

final class HomeCollectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "collectionHeaderId"

    private let titleLabel = Views.titleLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String) {
        titleLabel.text = title
    }

    private func setupView() {
        addSubview(titleLabel)
        self.backgroundColor = UIColor.headerBackground
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private enum Views {
        @MainActor
        static func titleLabel() -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 36)
            label.textColor = UIColor.headerText
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }
    }
}
