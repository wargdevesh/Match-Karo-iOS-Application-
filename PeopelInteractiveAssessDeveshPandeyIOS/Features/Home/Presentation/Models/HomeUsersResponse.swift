import Foundation



struct HomeUsersResponse: Codable, Equatable {
    let results: [HomeUser]
    let info: HomeUsersInfo
}

enum ProfileStatus: String {
    case none = "none"
    case accepted = "accepted"
    case declined = "declined"
}

struct HomeUser: Codable, Equatable, Identifiable {
    var id: String { login.uuid }

    let gender: String
    let name: HomeUserName
    let location: HomeUserLocation
    let email: String
    let login: HomeUserLogin
    let dob: HomeUserDateInfo
    let registered: HomeUserDateInfo
    let phone: String
    let cell: String
    let userID: HomeUserID
    let picture: HomeUserPicture
    let nat: String
    var profileStatus: ProfileStatus = .none

    enum CodingKeys: String, CodingKey {
        case gender
        case name
        case location
        case email
        case login
        case dob
        case registered
        case phone
        case cell
        case userID = "id"
        case picture
        case nat
    }
}

struct HomeUserName: Codable, Equatable {
    let title: String
    let first: String
    let last: String
}

struct HomeUserLocation: Codable, Equatable {
    let street: HomeUserStreet
    let city: String
    let state: String
    let country: String
    let postcode: HomeUserPostcode
    let coordinates: HomeUserCoordinates
    let timezone: HomeUserTimezone
}

struct HomeUserStreet: Codable, Equatable {
    let number: Int
    let name: String
}

struct HomeUserCoordinates: Codable, Equatable {
    let latitude: String
    let longitude: String
}

struct HomeUserTimezone: Codable, Equatable {
    let offset: String
    let description: String
}

struct HomeUserLogin: Codable, Equatable {
    let uuid: String
    let username: String
    let password: String
    let salt: String
    let md5: String
    let sha1: String
    let sha256: String
}

struct HomeUserDateInfo: Codable, Equatable {
    let date: String
    let age: Int
}

struct HomeUserID: Codable, Equatable {
    let name: String
    let value: String?
}

struct HomeUserPicture: Codable, Equatable {
    let large: String
    let medium: String
    let thumbnail: String
}

struct HomeUsersInfo: Codable, Equatable {
    let seed: String
    let results: Int
    let page: Int
    let version: String
}

enum HomeUserPostcode: Codable, Equatable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intValue = try? container.decode(Int.self) {
            self = .integer(intValue)
            return
        }

        let stringValue = try container.decode(String.self)
        self = .string(stringValue)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .integer(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
}
