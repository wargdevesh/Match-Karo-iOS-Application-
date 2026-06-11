protocol HomeNetworkServicing {
    func fetchUsers(results: Int) async throws -> HomeUsersResponse
}

struct HomeNetworkManager: HomeNetworkServicing {
    private let dispatcher: any NetworkDispatcher

    init(dispatcher: any NetworkDispatcher = URLSessionNetworkDispatcher()) {
        self.dispatcher = dispatcher
    }

    func fetchUsers(results: Int) async throws -> HomeUsersResponse {
        try await dispatcher.request(HomeEndpoint.users(results: results))
    }
}
