import Foundation
import Combine
import SwiftUI

@MainActor
final class HomeScreenViewModel: ObservableObject {
    @Published var title: String
    @Published private(set) var users: [HomeUser] = []
    @Published private(set) var dbUsers: [ProfileModel] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    
    let systemImageName: String
    
    private let networkManager: any HomeNetworkServicing
    private let homeListManager: any HomeListManageable
    private var cancellables = Set<AnyCancellable>()
    
    private var resultSize: Int = 10
    
    init(
        title: String = "Hello, world!",
        systemImageName: String = "globe",
        resultSize: Int = 10,
        networkManager: any HomeNetworkServicing,
        homeListManager: any HomeListManageable
    ) {
        self.title = title
        self.systemImageName = systemImageName
        self.resultSize = resultSize
        self.networkManager = networkManager
        self.homeListManager = homeListManager
        setupContextChangeObserver()
    }
    
    func setupContextChangeObserver() {
        homeListManager.contextChangedPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                // Handle the change, e.g., refetch data
                self?.getDataFromDB()
            }
            .store(in: &cancellables)
        
    }

func getDataFromDB() {
    Task {
        
       try Task.checkCancellation()
        do {
            let data =  try await homeListManager.getAll() ?? []
            try Task.checkCancellation()
           // withAnimation{
                dbUsers = []
                dbUsers = data
           // }
        }
        catch {
            errorMessage = error.localizedDescription
        }
    }
}

func saveUserToDB(users: [HomeUser]) {
    Task.detached { [weak self] in
        guard let self = self else {
            return
        }
        do {
            try await self.homeListManager.saveUsers(users: users)
        }
        catch{
            
        }
    }
}

func deleteUsersFromDB() async {
  //  Task {
        do {
            try await homeListManager.deleteAll()
        }catch{
            
        }
   // }
}
    func getMoreData() {
        Task.detached { [weak self] in
            guard let self = self else { return }
            await self.fetchUsers()
        }
    }

func fetchUsers() async {
    guard !isLoading else { return }
    
    isLoading = true
    errorMessage = nil
    
    do {
        let response = try await networkManager.fetchUsers(results: resultSize)
        users = response.results
        if resultSize  == 10 {
            await deleteUsersFromDB()
        }
        saveUserToDB(users: response.results)
        resultSize += 10
        title = "Loaded \(response.results.count) users"
    } catch {
        errorMessage = dbUsers.count == 0 ? error.localizedDescription : nil
        title = "Unable to load users"
    }
    
    isLoading = false
}

func changeStatus(status: ProfileStatus,user: ProfileModel) {
    if let index = dbUsers.firstIndex(where: {$0.id == user.id}) {
        Task {
            
             try await homeListManager.updateProfileStatus(id: dbUsers[index].id, newStatus: status.rawValue)
        }
    }
}
}

