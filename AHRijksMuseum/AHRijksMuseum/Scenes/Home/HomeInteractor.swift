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
        } catch let error as ArtServiceError {
            await responses.presentError(response: HomeError.Response(error: error))
        } catch {
            await responses.presentError(response: HomeError.Response(error: .unknown))
        }
    }

    func doLoadNextPage(request: HomeLoadNextPage.Request) async {
        actualPage += 1
        do {
            let requestResult = try await artService.fetchArts(page: actualPage)
            arts.append(requestResult)
            await responses.presentNextPage(response: HomeLoadNextPage.Response(arts: requestResult))
        } catch let error as ArtServiceError {
            actualPage -= 1
            await responses.presentError(response: HomeError.Response(error: error))
        } catch {
            actualPage -= 1
            await responses.presentError(response: HomeError.Response(error: .unknown))
        }
    }

    func getArts() -> [[ArtHomeModel]] {
        arts
    }
}
