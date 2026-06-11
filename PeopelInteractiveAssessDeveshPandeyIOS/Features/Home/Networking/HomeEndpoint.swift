import Foundation

enum HomeEndpoint: Endpoint {
    case users(results: Int)

    var baseURL: URL {
        guard let url = URL(string: "https://randomuser.me") else {
            preconditionFailure("Invalid Random User API base URL")
        }

        return url
    }

    var path: String {
        switch self {
        case .users:
            return "api"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .users:
            return .get
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .users(let results):
            return [URLQueryItem(name: "results", value: String(results))]
        }
    }

    var headers: [String: String] {
        ["Accept": "application/json"]
    }
}
