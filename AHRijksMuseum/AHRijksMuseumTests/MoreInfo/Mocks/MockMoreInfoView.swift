@testable import AHRijksMuseum

actor MockMoreInfoView: MoreInfoView {
    var displayLoadedDataView: MoreInfoInitialData.View?
    var displayRemoteDataView: MoreInfoRemoteData.View?
    var displayError: MoreInfoError.View?

    func displayLoadedData(view: MoreInfoInitialData.View) {
        displayLoadedDataView = view
    }

    func displayRemoteData(view: MoreInfoRemoteData.View) {
        displayRemoteDataView = view
    }

    func displayError(view: MoreInfoError.View) {
        displayError = view
    }
}
