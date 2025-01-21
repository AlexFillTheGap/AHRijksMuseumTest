import Foundation
import UIKit

protocol HomeRouting {
    func goToMoreInfo(indexPath: IndexPath) async
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore { get set }
}

final class HomeRouter: HomeRouting, HomeDataPassing {
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore

    init(viewController: HomeViewController, dataStore: HomeDataStore) {
        self.viewController = viewController
        self.dataStore = dataStore
    }

    @MainActor
    func goToMoreInfo(indexPath: IndexPath) async {
        guard
            let navigationController = viewController?.navigationController,
            await indexPath.section < dataStore.arts.count,
            await indexPath.row < dataStore.arts[indexPath.section].count
        else { return }

        let destinationVC = MoreInfoViewController(nibName: nil, bundle: nil)
        let artHome = await dataStore.arts[indexPath.section][indexPath.row]
        let moreInfoDetails = MoreInfoModel(from: artHome)
        await destinationVC.router?.dataStore.setArt(art: moreInfoDetails)
        navigationController.pushViewController(destinationVC, animated: true)
    }
}
