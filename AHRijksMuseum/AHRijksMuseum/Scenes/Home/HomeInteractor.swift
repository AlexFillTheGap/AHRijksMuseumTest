import Foundation

protocol HomeRequests {
    func doLoadData(request: HomeLoadData.Request) async
}

protocol HomeDataStore: AnyObject {
    var arts: [[ArtHomeModel]] { get async }
}

actor HomeInteractor: HomeRequests, HomeDataStore {
    var actualPage = 1
    private let responses: HomeResponses
    private let artService: ArtServicesProtocol
    private var loadingNextPage = false

    var arts: [[ArtHomeModel]] = []

    init(homeResponses: HomeResponses, artService: ArtServicesProtocol = ArtServices()) {
        responses = homeResponses
        self.artService = artService
    }

    func doLoadData(request: HomeLoadData.Request) async {
        await responses.presentDataLoaded(response: HomeLoadData.Response(arts: []))
    }
}
