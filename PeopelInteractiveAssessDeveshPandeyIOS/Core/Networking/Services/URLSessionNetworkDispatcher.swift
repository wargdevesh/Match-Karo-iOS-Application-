import Foundation

struct URLSessionNetworkDispatcher: NetworkDispatcher {
    private let urlSession: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(
        urlSession: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.urlSession = urlSession
        self.decoder = decoder
        self.encoder = encoder
    }

    func request<Response: Decodable>(_ endpoint: Endpoint) async throws -> Response {
        let request = try makeURLRequest(from: endpoint)

        do {
            let (data, response) = try await urlSession.data(for: request)
            try validate(response)

            do {
                return try decoder.decode(Response.self, from: data)
            } catch {
                throw NetworkError.decodingFailed(error.localizedDescription)
            }
        } catch let error as NetworkError {
            throw error
        } catch let error as URLError {
            throw mapURLError(error)
        } catch {
            throw NetworkError.requestFailed(error.localizedDescription)
        }
    }

    private func makeURLRequest(from endpoint: Endpoint) throws -> URLRequest {
        guard var components = URLComponents(
            url: endpoint.baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkError.invalidURL
        }

        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let body = endpoint.body {
            request.httpBody = try encodedBody(body)
        }

        return request
    }

    private func encodedBody(_ body: HTTPBody) throws -> Data {
        switch body {
        case .json(let encodable):
            do {
                return try encoder.encode(AnyEncodable(encodable))
            } catch {
                throw NetworkError.requestFailed(error.localizedDescription)
            }
        }
    }

    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpStatusCode(httpResponse.statusCode)
        }
    }

    private func mapURLError(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost, .timedOut, .cannotFindHost, .cannotConnectToHost:
            return .connectivity(error.localizedDescription)
        default:
            return .requestFailed(error.localizedDescription)
        }
    }
}

private struct AnyEncodable: Encodable {
    private let encodeClosure: (Encoder) throws -> Void

    init(_ encodable: any Encodable) {
        self.encodeClosure = encodable.encode(to:)
    }

    func encode(to encoder: Encoder) throws {
        try encodeClosure(encoder)
    }
}
