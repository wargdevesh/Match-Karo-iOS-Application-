//
//  ProfileModel.swift
//  PeopelInteractiveAssessDeveshPandeyIOS
//
//  Created by Devesh Pandey on 11/06/26.
//


import Foundation

public struct ProfileModel: Identifiable, Equatable {
    public let id: String
     let name: String
     let age: String
     let address: String
     let status: ProfileStatus
     let image: String
    
    public init(
        id: String = UUID().uuidString,
        name: String = "",
        age: String = "",
        address: String = "",
        status: String = "",
        image: String = ""
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.address = address
        self.status = ProfileStatus(rawValue: status) ?? .none
        self.image = image
    }
}
