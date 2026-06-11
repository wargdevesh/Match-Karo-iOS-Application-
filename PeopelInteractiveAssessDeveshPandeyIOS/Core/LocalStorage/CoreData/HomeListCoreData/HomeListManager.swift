//
//  HomeListManager.swift
//  PeopelInteractiveAssessDeveshPandeyIOS
//
//  Created by Devesh Pandey on 11/06/26.
//


import Foundation
import CoreData
import Combine

protocol HomeListManageable: AnyObject {
    func saveUsers(users: [HomeUser]) async throws
    func getAll() async throws -> [ProfileModel]
    func deleteAll() async throws -> Bool
    var contextChangedPublisher: AnyPublisher<Bool, Never> { get }
    func updateProfileStatus(id: String, newStatus: String) async throws -> Bool
    
}

public final class HomeListManager: NSObject, ObservableObject, @unchecked Sendable, NSFetchedResultsControllerDelegate, HomeListManageable {
    var contextChangedPublisher: AnyPublisher<Bool, Never> {
        $contextChanged.eraseToAnyPublisher()
    }
    
    
    private let homeListRepository = HomeListRepository()
    
    // MARK: - Core Data Contexts
    lazy var readContext: NSManagedObjectContext = {
        CoreDataStackNew.shared.mainContext
    }()
    
    lazy var writeContext: NSManagedObjectContext = {
        CoreDataStackNew.shared.newBackgroundContext()
    }()
    
    // MARK: - Published State
    @Published var contextChanged: Bool = false
    @Published var updatedProfiles: [ProfileModel] = []
    
    // MARK: - Init / Deinit
    public override init() {
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextDidSave(_:)),
            name: Notification.Name.NSManagedObjectContextDidSave,
            object: writeContext
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Observers
    @objc func contextDidSave(_ notification: Notification) {
        // Pushed to the main thread to safely update @Published property and prevent SwiftUI crashes
        DispatchQueue.main.async { [weak self] in
            self?.contextChanged.toggle()
        }
    }
    
    // MARK: - Operations
     func saveUsers(users: [HomeUser]) async throws {
        try await homeListRepository.create(users: users, writeContext: writeContext)
    }
    
     func getAll() async throws -> [ProfileModel] {
        do {
            let data = try await homeListRepository.getAll(readContext: readContext)
            return data.map { $0.toLocalModel() }
        } catch {
            throw LocalStorageError.fetchFailed(error.localizedDescription)
        }
    }
    
     func deleteAll() async throws -> Bool {
        return try await homeListRepository.deleteAll(writeContext: writeContext)
    }
    
    func updateProfileStatus(id: String, newStatus: String) async throws -> Bool {
        return try await homeListRepository.updateStatus(
            id: id,
            newStatus: newStatus,
            writeContext: writeContext
        )
    }
}
