@testable import AHRijksMuseum

final class MockArtServicesError: ArtServicesProtocol {

    func fetchArts(page: Int) async throws -> [ArtHomeModel] {
        throw NetworkError.server
    }

    func fetchArtDetail(artId: String) async throws -> MoreInfoModel {
        throw NetworkError.server
    }
}
