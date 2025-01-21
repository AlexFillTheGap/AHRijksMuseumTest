import Foundation

protocol ArtServicesProtocol: Sendable {
    func fetchArts(page: Int) async throws -> [ArtHomeModel]
}

final class ArtServices: ArtServicesProtocol {
    private let numberOfResultsPerPage = 20

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
}

private enum ArtRoutes: NetworkRoute {
    case fetchArts(page: Int, numberResults: Int)

    var path: String {
        switch self {
        case .fetchArts:
            return "/api/en/collection"
        }
    }

    var queryItems: [String: Any] {
        switch self {
        case .fetchArts(let page, let numberResults):
            return [
                "p": page,
                "ps": numberResults
            ]
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

    var errorDescription: String? {
        switch self {
        case .serverError:
            return String(localized: "error_description_server")
        case .fetchListError:
            return String(localized: "error_description_fetch_list")
        }
    }

    var failureReason: String? {
        switch self {
        case .serverError:
            return String(localized: "error_reason_server")
        case .fetchListError:
            return String(localized: "error_reason_fetch_list")
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .serverError:
            return String(localized: "error_suggestion_server")
        case .fetchListError:
            return String(localized: "error_suggestion_fetch_list")
        }
    }
}
