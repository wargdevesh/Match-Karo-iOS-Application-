protocol NetworkDispatcher {
    func request<Response: Decodable>(_ endpoint: Endpoint) async throws -> Response
}
