@testable import AHRijksMuseum

actor MockHomePresenter: HomeResponses {
    var presentDataLoadedResponse: HomeLoadData.Response?
    var presentNextPageResponse: HomeLoadNextPage.Response?
    var presentErrorResponse: HomeError.Response?

    func presentDataLoaded(response: HomeLoadData.Response) {
        presentDataLoadedResponse = response
    }

    func presentNextPage(response: HomeLoadNextPage.Response) {
        presentNextPageResponse = response
    }

    func presentError(response: HomeError.Response) {
        presentErrorResponse = response
    }
}
