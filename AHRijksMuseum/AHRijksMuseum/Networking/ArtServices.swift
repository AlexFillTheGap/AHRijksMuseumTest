import Foundation

protocol ArtServicesProtocol: Sendable {
    func fetchArts(page: Int) async throws -> [ArtHomeModel]
}

final class ArtServices: ArtServicesProtocol {
    private let numberOfResultsPerPage = 20

    func fetchArts(page: Int) async throws -> [ArtHomeModel] {
        return []
    }
}
