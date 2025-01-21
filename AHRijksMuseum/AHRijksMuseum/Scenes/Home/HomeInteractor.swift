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
        do {
            let requestResult = try await artService.fetchArts(page: actualPage)
            arts.append(requestResult)
            await responses.presentDataLoaded(response: HomeLoadData.Response(arts: requestResult))
        } catch let error as NetworkError {
            // TODO: Present error.
        } catch {
            print("an error happens during doLoadData method")
        }

    }
}
