import Foundation
import UIKit

protocol MoreInfoResponses: Sendable {
    func presentLoadedData(response: MoreInfoInitialData.Response) async
}

final class MoreInfoPresenter: MoreInfoResponses {
    private let view: MoreInfoView

    init(moreInfoView: MoreInfoView) {
        self.view = moreInfoView
    }

    func presentLoadedData(response: MoreInfoInitialData.Response) async {
        let artViewModel = MoreInfoLocalViewModel(
            screenTitle: response.artMoreInfo.screenTitle,
            imageUrlString: response.artMoreInfo.imageUrlString,
            title: response.artMoreInfo.title
        )
        await view.displayLoadedData(view: MoreInfoInitialData.View(artViewModel: artViewModel))
    }
}
