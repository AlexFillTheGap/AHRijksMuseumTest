import Foundation

protocol HomeResponses {
    func presentDataLoaded(response: HomeLoadData.Response)
}

final class HomePresenter: HomeResponses {
    private let view: HomeView

    init(homeView: HomeView) {
        view = homeView
    }

    func presentDataLoaded(response: HomeLoadData.Response) {
        let items = response.arts.map { model in
            ItemViewModel(imageUrlString: model.listImageUrlString, title: model.listTitle)
        }
        view.displayNewData(view: HomeLoadData.View(arts: items))
    }

}
