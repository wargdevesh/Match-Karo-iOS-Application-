//
//  ProfileInfo+CoreDataProperties.swift
//  PeopelInteractiveAssessDeveshPandeyIOS
//
//  Created by Devesh Pandey on 11/06/26.
//
//

public import Foundation
public import CoreData


public typealias ProfileInfoCoreDataPropertiesSet = NSSet

extension ProfileInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileInfo> {
        return NSFetchRequest<ProfileInfo>(entityName: "ProfileInfo")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var age: String?
    @NSManaged public var address: String?
    @NSManaged public var status: String?
    @NSManaged public var image: String?

}

//extension ProfileInfo : Identifiable {
//
//}
extension ProfileInfo {
    
    /// Converts the Core Data managed object to a local, SwiftUI-friendly value type.
    public func toLocalModel() -> ProfileModel {
        return ProfileModel(
            // NOTE: Generating a new UUID() on every fetch works for simple use cases,
            // but if you are constantly refetching data, it will recreate the IDs and
            // break SwiftUI List animations.
            // If possible, add a persistent `id` to your Core Data entity in the future.
            id: self.id ?? UUID().uuidString,
            name: self.name ?? "",
            age: self.age ?? "",
            address: self.address ?? "",
            status: self.status ?? "",
            image: self.image ?? ""
        )
    }
}
