@testable import AHRijksMuseum

class MockHomeView: HomeView {
    var displayNewDataView: HomeLoadData.View?
    var displayNextPageView: HomeLoadNextPage.View?
    var displayErrorView: HomeError.View?

    func displayNewData(view: HomeLoadData.View) {
        displayNewDataView = view
    }

    func displayNextPage(view: HomeLoadNextPage.View) {
        displayNextPageView = view
    }

    func displayError(view: HomeError.View) {
        displayErrorView = view
    }
}
