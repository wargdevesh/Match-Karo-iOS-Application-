import Foundation

enum LocalStorageError: Error, LocalizedError, Equatable {
    case fetchFailed(String)
    case saveFailed(String)
    case deleteFailed(String)
    case updateFailed(String)
    case recordNotFound

    var errorDescription: String? {
        switch self {
        case .fetchFailed(let message):
            return "Could not fetch saved profiles. \(message)"
        case .saveFailed(let message):
            return "Could not save profiles. \(message)"
        case .deleteFailed(let message):
            return "Could not clear saved profiles. \(message)"
        case .updateFailed(let message):
            return "Could not update the profile status. \(message)"
        case .recordNotFound:
            return "The selected profile could not be found."
        }
    }
}
