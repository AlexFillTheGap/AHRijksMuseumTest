import Foundation
import UIKit

@MainActor
protocol HomeView: Sendable {
    func displayNewData(view: HomeLoadData.View)
}

@MainActor
final class HomeViewController: UIViewController {
    private var requests: HomeRequests?
    var router: (HomeRouting & HomeDataPassing)?

    private let loaderView = UIActivityIndicatorView.loaderView()

    private var collectionItems: [[ItemViewModel]] = []

    // MARK: Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Object lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        let interactor = requests
        Task {
            await interactor?.doLoadData(request: HomeLoadData.Request())
        }
    }

    // MARK: Private Methods

    private func setup() {
        let presenter = HomePresenter(homeView: self)
        let interactor = HomeInteractor(homeResponses: presenter)
        requests = interactor
        router = HomeRouter(viewController: self, dataStore: interactor)
    }

    private func setupView() {
        title = String(localized: "home_screen_title")
        view.backgroundColor = UIColor.background
    }
}

// MARK: - HomeView

extension HomeViewController: HomeView {
    func displayNewData(view: HomeLoadData.View) {

    }
}
