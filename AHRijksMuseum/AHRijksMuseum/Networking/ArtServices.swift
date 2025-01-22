import Foundation

protocol ArtServicesProtocol: Sendable {
    func fetchArts(page: Int) async throws -> [ArtHomeModel]
    func fetchArtDetail(artId: String) async throws -> MoreInfoModel
}

final class ArtServices: ArtServicesProtocol {
    private let numberOfResultsPerPage = 20
    private let networkManager = NetworkManager()

    func fetchArts(page: Int) async throws -> [ArtHomeModel] {
        do {
            let route = ArtRoutes.fetchArts(page: page, numberResults: numberOfResultsPerPage)
            let data = try await NetworkManager.shared.performRequest(with: route)
            let parsedData: ArtHomeData = try DecodeHelper.decodeData(data: data)

            return parsedData.arts
        } catch NetworkError.server {
            throw ArtServiceError.serverError
        } catch {
            throw ArtServiceError.fetchListError
        }
    }

    func fetchArtDetail(artId: String) async throws -> MoreInfoModel {
        do {
            let route = ArtRoutes.fetchArtDetail(artId: artId)
            let data = try await NetworkManager.shared.performRequest(with: route)
            let parsedData: MoreInfoData = try DecodeHelper.decodeData(data: data)

            return parsedData.art
        } catch NetworkError.server {
            throw ArtServiceError.serverError
        } catch {
            throw ArtServiceError.fetchDetailError
        }
    }
}

private enum ArtRoutes: NetworkRoute {
    case fetchArts(page: Int, numberResults: Int)
    case fetchArtDetail(artId: String)

    var path: String {
        switch self {
        case .fetchArts:
            return "/api/en/collection"
        case .fetchArtDetail(let artId):
            return "/api/en/collection/\(artId)"
        }
    }

    var queryItems: [String: Any] {
        switch self {
        case .fetchArts(let page, let numberResults):
            return [
                "p": page,
                "ps": numberResults
            ]
        case .fetchArtDetail:
            return [:]
        }
    }

    var body: Data? {
        nil
    }

    var type: NetworkRequestType {
        .get
    }

    var needsAuth: Bool {
        true
    }
}

enum ArtServiceError: LocalizedError {
    case serverError
    case fetchListError
    case fetchDetailError

    var errorDescription: String? {
        switch self {
        case .serverError:
            return String(localized: "error_description_server")
        case .fetchListError:
            return String(localized: "error_description_fetch_list")
        case .fetchDetailError:
            return String(localized: "error_description_fetch_detail")
        }
    }

    var failureReason: String? {
        switch self {
        case .serverError:
            return String(localized: "error_reason_server")
        case .fetchListError:
            return String(localized: "error_reason_fetch_list")
        case .fetchDetailError:
            return String(localized: "error_reason_fetch_detail")
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .serverError:
            return String(localized: "error_suggestion_server")
        case .fetchListError:
            return String(localized: "error_suggestion_fetch_list")
        case .fetchDetailError:
            return String(localized: "error_suggestion_fetch_detail")
        }
    }
}
