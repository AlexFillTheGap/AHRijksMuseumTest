import Foundation

protocol HomeResponses: Sendable {
    func presentDataLoaded(response: HomeLoadData.Response) async
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

}
