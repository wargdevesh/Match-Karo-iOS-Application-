import Foundation
@testable import PeopelInteractiveAssessDeveshPandeyIOS

final class MockNetworkDispatcher: NetworkDispatcher {
    enum MockResponse {
        case success(Data)
        case failure(NetworkError)
    }

    private let response: MockResponse
    private let decoder: JSONDecoder

    private(set) var requestedEndpoints: [Endpoint] = []

    init(response: MockResponse, decoder: JSONDecoder = JSONDecoder()) {
        self.response = response
        self.decoder = decoder
    }

    convenience init(jsonString: String, decoder: JSONDecoder = JSONDecoder()) {
        let data = Data(jsonString.utf8)
        self.init(response: .success(data), decoder: decoder)
    }

    convenience init(error: NetworkError) {
        self.init(response: .failure(error))
    }

    func request<Response: Decodable>(_ endpoint: Endpoint) async throws -> Response {
        requestedEndpoints.append(endpoint)

        switch response {
        case .success(let data):
            do {
                return try decoder.decode(Response.self, from: data)
            } catch {
                throw NetworkError.decodingFailed(error.localizedDescription)
            }
        case .failure(let error):
            throw error
        }
    }
}
