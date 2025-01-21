import UIKit

class HomeCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = "collectionItemId"

    private let imageView = Views.imageView()
    private let titleLabel = Views.titleLabel()
    private let titleBackgroundView = Views.titleBackgroundView()

    private var imageBeingLoadedUrlString: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        imageView.image = nil
        titleLabel.text = ""
        super.prepareForReuse()
    }

    func configureCell(with data: ItemViewModel, index: IndexPath) {
        titleLabel.text = data.title
        imageBeingLoadedUrlString = data.imageUrlString
        Task {
            let (artImage, usedUrlString) = await ImageCache.shared.load(urlString: data.imageUrlString)
            guard usedUrlString == imageBeingLoadedUrlString  else {
                return
            }
            UIView.transition(
                with: self.imageView,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: {
                    self.imageView.image = artImage
                },
                completion: nil
            )
        }
    }

    private func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleBackgroundView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            titleBackgroundView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -12),
            titleBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

private enum Views {
    @MainActor static func imageView() -> UIImageView {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = UIColor.imageBackGround
        return image
    }

    @MainActor static func titleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.foreground
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    @MainActor static func titleBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.imageLayerBackground
        view.layer.opacity = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
