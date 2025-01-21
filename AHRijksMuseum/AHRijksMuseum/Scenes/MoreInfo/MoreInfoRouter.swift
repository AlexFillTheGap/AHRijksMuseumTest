import Foundation

protocol MoreInfoRouting {}

protocol MoreInfoDataPassing {
    var dataStore: MoreInfoDataStore { get set }
}

final class MoreInfoRouter: MoreInfoRouting, MoreInfoDataPassing {
    weak var viewController: MoreInfoViewController?
    var dataStore: MoreInfoDataStore

    init(viewController: MoreInfoViewController, dataStore: MoreInfoDataStore) {
        self.viewController = viewController
        self.dataStore = dataStore
    }
}
