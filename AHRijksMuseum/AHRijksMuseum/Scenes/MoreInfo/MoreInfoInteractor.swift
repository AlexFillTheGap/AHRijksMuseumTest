import Foundation

protocol MoreInfoRequests {
    func doLoadInitialData(request: MoreInfoInitialData.Request) async
    func doLoadRemoteData(request: MoreInfoRemoteData.Request) async
}

protocol MoreInfoDataStore: Actor {
    var art: MoreInfoModel? { get set }
    func setArt(art: MoreInfoModel) async
}

actor MoreInfoInteractor: MoreInfoRequests, MoreInfoDataStore {
    var art: MoreInfoModel?
    private let responses: MoreInfoResponses
    private let artService: ArtServicesProtocol

    init(moreInfoResponses: MoreInfoResponses, artService: ArtServicesProtocol = ArtServices()) {
        responses = moreInfoResponses
        self.artService = artService
    }

    func doLoadInitialData(request: MoreInfoInitialData.Request) async {
        guard let art else { return }
        await responses.presentLoadedData(response: MoreInfoInitialData.Response(artMoreInfo: art))
    }

    func doLoadRemoteData(request: MoreInfoRemoteData.Request) async {
        guard let art else { return }
        do {
            let requestResult = try await artService.fetchArtDetail(artId: art.identifier)
            self.art = requestResult
            await responses.presentRemoteData(response: MoreInfoRemoteData.Response(artMoreInfo: requestResult))
        } catch let error as NetworkError {
            await responses.presentError(response: MoreInfoError.Response(error: error))
        } catch {
            await responses.presentError(response: MoreInfoError.Response(error: NetworkError.connection))
        }
    }

    func setArt(art: MoreInfoModel) async {
        self.art = art
    }
}
