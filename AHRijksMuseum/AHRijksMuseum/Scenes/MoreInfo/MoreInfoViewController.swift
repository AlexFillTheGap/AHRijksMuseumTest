import UIKit

protocol MoreInfoView: Sendable {
    func displayLoadedData(view: MoreInfoInitialData.View) async
}

class MoreInfoViewController: UIViewController {
    private var requests: MoreInfoRequests?
    var router: (MoreInfoRouting & MoreInfoDataPassing)?

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
    }

    private func setupView() {
        view.backgroundColor = UIColor.background
    }
}

extension MoreInfoViewController: MoreInfoView {
    func displayLoadedData(view: MoreInfoInitialData.View) {}

}
