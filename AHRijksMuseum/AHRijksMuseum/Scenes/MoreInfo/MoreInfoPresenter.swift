import Foundation
import UIKit

protocol MoreInfoResponses: Sendable {
    func presentLoadedData(response: MoreInfoInitialData.Response) async
    func presentRemoteData(response: MoreInfoRemoteData.Response) async
    func presentError(response: MoreInfoError.Response) async
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

    func presentRemoteData(response: MoreInfoRemoteData.Response) async {
        let artViewModel = MoreInfoRemoteViewModel(
            title: response.artMoreInfo.screenTitle,
            description: response.artMoreInfo.description,
            imageBackgroundColor: UIColor(response.artMoreInfo.imageBackgroundColorString)
        )
        await view.displayRemoteData(view: MoreInfoRemoteData.View(artViewModel: artViewModel))
    }

    func presentError(response: MoreInfoError.Response) async {
        let errorViewModel = MoreInfoError.View(
            errorTitle: String(localized: "moreInfo_error_title"),
            errorMessage: response.error.errorDescription ?? ""
        )
        await view.displayError(view: errorViewModel)
    }
}
