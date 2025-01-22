import UIKit

protocol MoreInfoView: Sendable {
    func displayLoadedData(view: MoreInfoInitialData.View) async
    func displayRemoteData(view: MoreInfoRemoteData.View) async
}

class MoreInfoViewController: UIViewController {
    private var requests: MoreInfoRequests?
    var router: (MoreInfoRouting & MoreInfoDataPassing)?

    private let scrollView = Views.scrollView()
    private let imageView = Views.imageView()
    private let titleLabel = Views.titleLabel()
    private let descriptionLabel = Views.descriptionLabel()
    private let loaderView = UIActivityIndicatorView.loaderView()

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

    private func setup() {
        let presenter = MoreInfoPresenter(moreInfoView: self)
        let interactor = MoreInfoInteractor(moreInfoResponses: presenter)
        requests = interactor
        router = MoreInfoRouter(viewController: self, dataStore: interactor)
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loaderView.isHidden = false
        Task {
            await requests?.doLoadInitialData(request: MoreInfoInitialData.Request())
            await requests?.doLoadRemoteData(request: MoreInfoRemoteData.Request())
        }
    }

    private func setupView() {
        view.backgroundColor = UIColor.background
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(loaderView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            loaderView.centerXAnchor.constraint(equalTo: descriptionLabel.centerXAnchor),
            loaderView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16)
        ])
    }
}

extension MoreInfoViewController: MoreInfoView {
    func displayLoadedData(view: MoreInfoInitialData.View) {
        DispatchQueue.main.async {
            self.title = view.artViewModel.screenTitle
            self.titleLabel.text = view.artViewModel.title
            Task {
                let (image, _) = await ImageCache.shared.load(urlString: view.artViewModel.imageUrlString)
                UIView.transition(
                    with: self.imageView,
                    duration: 0.3,
                    options: .transitionCrossDissolve,
                    animations: {
                        self.imageView.image = image
                    },
                    completion: nil
                )
            }
        }
    }

    func displayRemoteData(view: MoreInfoRemoteData.View) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.loaderView.isHidden = true
                self.imageView.backgroundColor = view.artViewModel.imageBackgroundColor
                self.descriptionLabel.text = view.artViewModel.description
                self.title = view.artViewModel.title
            }
        }
    }
}

// MARK: - UI

private enum Views {
    @MainActor static func scrollView() -> UIScrollView {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }

    @MainActor static func imageView() -> UIImageView {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }

    @MainActor static func titleLabel() -> UILabel {
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.numberOfLines = 0
        title.lineBreakMode = .byClipping
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }

    @MainActor static func descriptionLabel() -> UILabel {
        let description = UILabel()
        description.numberOfLines = 0
        description.lineBreakMode = .byClipping
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }
}
