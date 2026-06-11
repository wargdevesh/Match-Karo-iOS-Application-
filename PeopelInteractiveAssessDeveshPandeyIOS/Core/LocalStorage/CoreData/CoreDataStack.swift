//
//  ProfileInfo+CoreDataClass.swift
//  PeopelInteractiveAssessDeveshPandeyIOS
//
//  Created by Devesh Pandey on 11/06/26.


import CoreData
import Foundation

public final class CoreDataContainer: NSPersistentContainer, @unchecked Sendable {
    public init(name: String, bundle: Bundle = .main, inMemory: Bool = false) {
        // Uses the provided bundle (defaulting to .main) to find the model
        guard let mom = NSManagedObjectModel.mergedModel(from: [bundle]) else {
            fatalError("Failed to create mom")
        }
        super.init(name: name, managedObjectModel: mom)
    }
}

// MARK: - Core Data Stack
public class CoreDataStackNew: @unchecked Sendable {
    public static let shared = CoreDataStackNew()
    
    private static let modelName: String = "ProfileModel"
    
    private init() {}
    
    // MARK: - Core Data Stack Properties
    private let storeContainer: CoreDataContainer = {
        // CHANGED: Replaced 'bundle: .module' with 'bundle: .main'
        let container = CoreDataContainer(name: CoreDataStackNew.modelName, bundle: .main)
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Failed to load Core Data stack: \(error), \(error.userInfo)")
            }
            
            if let storeURL = storeDescription.url {
                print("📁 Core Data Database Path:")
                print("CoreData: \(storeURL.path)")
                print("CoreData: \(storeURL.absoluteString)")
            }
        }
        
        // Merge changes from parent context automatically
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        
        // Configure viewContext for better performance
        container.viewContext.shouldDeleteInaccessibleFaults = true
        
        return container
    }()
    
    // MARK: - Core Data Contexts
    lazy var mainContext: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()
    
    public func newBackgroundContext() -> NSManagedObjectContext {
        let context = storeContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        return context
    }
    
    // MARK: - Core Data Saving
    public func saveContext() {
        guard mainContext.hasChanges else { return }
        
        do {
            try mainContext.save()
        } catch {
            print("Error saving main context: \(error)")
        }
    }
    
    public func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = newBackgroundContext()
        context.perform {
            block(context)
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("Error saving background context: \(error)")
                }
            }
        }
    }
    
    @discardableResult
    public func performBackgroundTask<T>(_ block: @escaping @Sendable (NSManagedObjectContext) throws -> T) async throws -> T {
        let context = newBackgroundContext()
        
        return try await context.perform {
            do {
                let result = try block(context)
                if context.hasChanges {
                    try context.save()
                }
                return result
            } catch {
                throw error
            }
        }
    }
}

// MARK: - Core Data Operations
extension CoreDataStackNew {
    // MARK: - Generic CRUD Operations
    public func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>, context: NSManagedObjectContext? = nil) throws -> [T] {
        let context = context ?? mainContext
        return try context.fetch(request)
    }
    
    public func delete<T: NSManagedObject>(_ object: T, context: NSManagedObjectContext? = nil) {
        let context = context ?? mainContext
        context.delete(object)
    }
    
    public func batchDelete(entityName: String, predicate: NSPredicate? = nil, context: NSManagedObjectContext? = nil) throws {
        let context = context ?? mainContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        let result = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [mainContext])
    }
    
    public func deleteAll(entityName: String, context: NSManagedObjectContext? = nil) throws {
        try batchDelete(entityName: entityName, predicate: nil, context: context)
        print("✅ All records for \(entityName) deleted successfully.")
    }
}


