import Foundation

protocol HomeResponses: Sendable {
    func presentDataLoaded(response: HomeLoadData.Response) async
    func presentNextPage(response: HomeLoadNextPage.Response) async
    func presentError(response: HomeError.Response) async
}

final class HomePresenter: HomeResponses {
    private let view: HomeView

    init(homeView: HomeView) {
        view = homeView
    }

    func presentDataLoaded(response: HomeLoadData.Response) async {
        let items = response.arts.map { model in
            ItemViewModel(imageUrlString: model.listImageUrlString, title: model.listTitle)
        }
        await view.displayNewData(view: HomeLoadData.View(arts: items))
    }

    func presentNextPage(response: HomeLoadNextPage.Response) async {
        let items = response.arts.map { model in
            ItemViewModel(imageUrlString: model.listImageUrlString, title: model.listTitle)
        }
        await view.displayNextPage(view: HomeLoadNextPage.View(arts: items))
    }

    func presentError(response: HomeError.Response) async {
        let viewModel = HomeError.View(
            errorTitle: String(
                localized: "home_error_title"
            ),
            errorMessage: response.error.errorDescription ?? ""
        )
        await view.displayError(view: viewModel)
    }
}
