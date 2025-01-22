@testable import AHRijksMuseum

actor MockMoreInfoPresenter: MoreInfoResponses {
    var presentDataLoadedResponse: MoreInfoInitialData.Response?
    var presentRemoteDataLoadedResponse: MoreInfoRemoteData.Response?
    var presentErrorResponse: MoreInfoError.Response?

    func presentLoadedData(response: MoreInfoInitialData.Response) {
        presentDataLoadedResponse = response
    }

    func presentRemoteData(response: MoreInfoRemoteData.Response) {
        presentRemoteDataLoadedResponse = response
    }

    func presentError(response: MoreInfoError.Response) {
        presentErrorResponse = response
    }
}
