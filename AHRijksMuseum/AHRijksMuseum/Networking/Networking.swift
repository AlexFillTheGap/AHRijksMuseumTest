import Foundation

// API used for the example: https://data.rijksmuseum.nl/object-metadata/api/

protocol Networking: Sendable {
    func performRequest(with route: NetworkRoute) async throws -> Data
}

struct NetworkManager: Networking {
    private let urlSession = URLSession.shared
    private let baseUrl: String = "https://data.rijksmuseum.nl/object-metadata/api/"
    private let apiKey: String = "0fiuZFh4"

    public static let shared = NetworkManager()

    func performRequest(with route: NetworkRoute) async throws -> Data {
        let request = try createRequest(from: route)
        return try await performRequest(request: request)
    }

    private func performRequest(request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)

        // Check for possible status code errors
        if let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode > 299 {
            throw NetworkError.fromStatusCode(urlResponse.statusCode)
        }

        return data
    }

    private func createRequest(from route: NetworkRoute) throws -> URLRequest {
        guard let baseUrl = URL(string: route.baseUrl), var url = URL(string: route.path, relativeTo: baseUrl) else {
            throw NetworkError.wrongUrl
        }

        url.append(queryItems: route.queryItems.map({ key, value in
            URLQueryItem(name: key, value: "\(value)")
        }))
        if route.needsAuth {
            url.append(queryItems: [URLQueryItem(name: "key", value: apiKey)])
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = route.type.rawValue
        urlRequest.httpBody = route.body
        route.headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }

        return urlRequest
    }
}

protocol NetworkRoute {
    var baseUrl: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var queryItems: [String: Any] { get }
    var body: Data? { get }
    var type: NetworkRequestType { get }
    var needsAuth: Bool { get }
}

// Common to all Services
extension NetworkRoute {
    var baseUrl: String {
        "https://data.rijksmuseum.nl/object-metadata/api/"
    }

    var headers: [String: String] {
        [:]
    }
}

enum NetworkRequestType: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case auth
    case client
    case server
    case connection
    case unknown
    case noData
    case wrongUrl
    case parseData

    static func fromStatusCode(_ code: Int) -> NetworkError {
        switch code {
        case 401, 403:
            return .auth
        case 402, 404...499:
            return .client
        case 500...599:
            return .server
        default:
            return .unknown
        }
    }

    var message: String {
        switch self {
        case .auth:
            return String(localized: "error_nt_auth_message")
        case .client:
            return String(localized: "error_nt_client_message")
        case .server:
            return String(localized: "error_nt_server_message")
        case .connection:
            return String(localized: "error_nt_connection_message")
        case .noData:
            return String(localized: "error_nt_no_data_message")
        case .unknown:
            return String(localized: "error_nt_unknown_message")
        case .wrongUrl:
            return String(localized: "error_nt_bad_url_message")
        case .parseData:
            return String(localized: "error_nt_parse_data_message")
        }
    }
}
