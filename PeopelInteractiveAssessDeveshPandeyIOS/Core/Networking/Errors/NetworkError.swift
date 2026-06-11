import Foundation

enum NetworkError: Error, LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case httpStatusCode(Int)
    case decodingFailed(String)
    case connectivity(String)
    case requestFailed(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .httpStatusCode(let statusCode):
            return "The request failed with status code \(statusCode)."
        case .decodingFailed(let message):
            return "The response could not be decoded. \(message)"
        case .connectivity(let message):
            return "A network connectivity error occurred. \(message)"
        case .requestFailed(let message):
            return "The network request failed. \(message)"
        }
    }
}
