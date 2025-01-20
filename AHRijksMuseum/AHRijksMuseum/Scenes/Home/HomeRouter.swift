import Foundation
import UIKit

protocol HomeRouting {
    func goToMoreInfo(indexPath: IndexPath)
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

    func goToMoreInfo(indexPath: IndexPath) { }
}
