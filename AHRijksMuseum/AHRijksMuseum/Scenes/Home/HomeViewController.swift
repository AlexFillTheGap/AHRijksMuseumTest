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

    private let collectionView = Views.collectionView()
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
        loaderView.isHidden = false
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

        view.addSubview(collectionView)
        view.addSubview(loaderView)

        collectionView.dataSource = self
        collectionView.delegate = self

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - HomeView

extension HomeViewController: HomeView {
    func displayNewData(view: HomeLoadData.View) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loaderView.isHidden = true
            self.collectionItems.append(view.arts)
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionItems.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionItems[section].count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeCollectionCell.reuseIdentifier,
            for: indexPath
        )
        guard let homeCell = cell as? HomeCollectionCell,
              collectionItems.count > indexPath.section,
              collectionItems[indexPath.section].count > indexPath.row else {
            return cell
        }
        homeCell.configureCell(with: collectionItems[indexPath.section][indexPath.row], index: indexPath)
        return homeCell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let view = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HomeCollectionHeaderView.reuseIdentifier,
                    for: indexPath
                )
                guard let headerView = view as? HomeCollectionHeaderView else {
                    return view
                }

                headerView.configure(
                    title: String(
                        format: String(localized: "home_section_header_title"),
                        indexPath.section + 1
                    )
                )
                return headerView
            default:
                assert(false, "Unexpected element kind")
            }
    }
}

// MARK: - UI

private enum Views {
    @MainActor
    static func collectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(HomeCollectionCell.self, forCellWithReuseIdentifier: HomeCollectionCell.reuseIdentifier)
        collectionView.register(
            HomeCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeCollectionHeaderView.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
}
