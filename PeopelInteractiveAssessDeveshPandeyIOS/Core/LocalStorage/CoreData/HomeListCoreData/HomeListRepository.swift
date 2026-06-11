import Foundation
import CoreData

protocol HomeListRepositoryProtocol {
    func create(users: [HomeUser], writeContext: NSManagedObjectContext) async throws
    func getAll(readContext: NSManagedObjectContext) async throws -> [ProfileInfo]
    func deleteAll(writeContext: NSManagedObjectContext) async throws -> Bool
    func updateStatus(id: String, newStatus: String, writeContext: NSManagedObjectContext) async throws -> Bool 
}

struct HomeListRepository: HomeListRepositoryProtocol {
    
    // MARK: - Create
    /// Maps an array of HomeUser models to ProfileInfo Core Data entities and saves them.
    func create(users: [HomeUser], writeContext: NSManagedObjectContext) async throws {
        try await writeContext.perform {
            for user in users {
                let uniqueID = user.login.uuid
                
                // 1. Check if an entity with this unique ID already exists
                let fetchRequest: NSFetchRequest<ProfileInfo> = ProfileInfo.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", uniqueID)
                fetchRequest.fetchLimit = 1
                
                let existingProfiles = try writeContext.fetch(fetchRequest)
                let profileEntity: ProfileInfo
                
                if let existingProfile = existingProfiles.first {
                    // Update matching existing record
                    profileEntity = existingProfile
                } else {
                    // Create a brand new record
                    profileEntity = ProfileInfo(context: writeContext)
                    profileEntity.id = uniqueID // Assign the permanent identifier
                }
                
                // 2. Map properties safely
                profileEntity.name = "\(user.name.first) \(user.name.last)"
                profileEntity.age = "\(user.dob.age)"
                profileEntity.address = "\(user.location.street.number) \(user.location.street.name), \(user.location.city)"
                profileEntity.status = String(describing: user.profileStatus)
                profileEntity.image = "\(user.picture.large)"
            }
            
            // 3. Persist modifications
            if writeContext.hasChanges {
                try writeContext.save()
            }
        }
    }
    
    // MARK: - Fetch All (Stays identical, but benefits from the new ID field)
    func getAll(readContext: NSManagedObjectContext) async throws -> [ProfileInfo] {
        return try await readContext.perform {
            let fetchRequest: NSFetchRequest<ProfileInfo> = ProfileInfo.fetchRequest()
            return try readContext.fetch(fetchRequest)
        }
    }
    
    // MARK: - Delete Single Record (Bonus addition to your CRUD ops)
    func delete(id: String, writeContext: NSManagedObjectContext) async throws -> Bool {
        return try await writeContext.perform {
            let fetchRequest: NSFetchRequest<ProfileInfo> = ProfileInfo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            fetchRequest.fetchLimit = 1
            
            if let entityToDelete = try? writeContext.fetch(fetchRequest).first {
                writeContext.delete(entityToDelete)
                try writeContext.save()
                return true
            }
            return false
        }
    }
    
    // MARK: - Delete All
    func deleteAll(writeContext: NSManagedObjectContext) async throws -> Bool {
        return try await writeContext.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ProfileInfo.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            
            let result = try writeContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
            let count = result?.result as? Int ?? 0
            writeContext.reset()
            return count > 0
        }
    }
    
    // MARK: - Update Single Attribute
    func updateStatus(id: String, newStatus: String, writeContext: NSManagedObjectContext) async throws -> Bool {
        return try await writeContext.perform {
            let fetchRequest: NSFetchRequest<ProfileInfo> = ProfileInfo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            fetchRequest.fetchLimit = 1
            
            // Fetch the specific record
            guard let entityToUpdate = try writeContext.fetch(fetchRequest).first else {
                throw LocalStorageError.recordNotFound
            }

                // Update the status
                entityToUpdate.status = newStatus
                
                // Save the changes
                if writeContext.hasChanges {
                    try writeContext.save()
                }
            return true // Successfully updated
        }
    }
}
