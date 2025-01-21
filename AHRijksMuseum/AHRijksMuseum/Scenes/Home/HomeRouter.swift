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
    func goToMoreInfo(indexPath: IndexPath) async { }
}
