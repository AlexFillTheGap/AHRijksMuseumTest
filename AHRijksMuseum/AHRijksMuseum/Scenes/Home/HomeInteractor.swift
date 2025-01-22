import Foundation

protocol HomeRequests {
    func doLoadData(request: HomeLoadData.Request) async
    func doLoadNextPage(request: HomeLoadNextPage.Request) async
}

protocol HomeDataStore: Actor {
    var arts: [[ArtHomeModel]] { get set }
    func getArts() -> [[ArtHomeModel]]
}

actor HomeInteractor: HomeRequests, HomeDataStore {
    var actualPage = 0
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
            await responses.presentError(response: HomeError.Response(error: error))
        } catch {
            print("an error happens during doLoadData method")
        }
    }

    func doLoadNextPage(request: HomeLoadNextPage.Request) async {
        guard !loadingNextPage else {
            return
        }
        loadingNextPage = true
        actualPage += 1
        do {
            let requestResult = try await artService.fetchArts(page: actualPage)
            arts.append(requestResult)
            await responses.presentNextPage(response: HomeLoadNextPage.Response(arts: requestResult))
            loadingNextPage = false
        } catch let error as NetworkError {
            actualPage -= 1
            loadingNextPage = false
            await responses.presentError(response: HomeError.Response(error: error))
        } catch {
            print("an error happens during doLoadNextPage method")
        }
    }

    func getArts() -> [[ArtHomeModel]] {
        arts
    }
}
