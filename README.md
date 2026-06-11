# PeopelInteractiveAssessDeveshPandeyIOS

An iOS profile-discovery app built with SwiftUI, UIKit navigation, async networking, and Core Data local storage. The app fetches profile data from the Random User API, stores it locally, and displays swipe-style profile cards with accept/decline actions.

## Features

- Profile card list built with SwiftUI `ScrollView` and `LazyVStack`
- UIKit `UINavigationController` based navigation coordinated from SwiftUI app entry
- Random User API integration using a protocol-oriented networking layer
- Core Data backed local profile storage
- Accept/decline status persistence
- Pagination trigger near the bottom of the list
- Bottom pagination loader
- Scroll offset preservation during pagination refreshes
- Image loading with `SDWebImageSwiftUI`

## Architecture

The project follows MVVM, Clean Architecture, coordinator navigation, protocol-oriented dependencies, and initializer dependency injection.

```text
PeopelInteractiveAssessDeveshPandeyIOS/
├── Core/
│   ├── Navigation/
│   ├── Networking/
│   └── LocalStorage/
└── Features/
    └── Home/
        ├── Navigation/
        ├── Networking/
        └── Presentation/
```

### Navigation

Navigation is managed by coordinators:

- `ApplicationCoordinator` owns the root `UINavigationController`
- `HomeFlowCoordinator` creates the Home dependencies and wraps `HomeScreen` in `UIHostingController`
- `NavigationControllerHost` bridges UIKit navigation into SwiftUI via `UIViewControllerRepresentable`

### Networking

The networking layer is under `Core/Networking` and uses native `URLSession` with async/await:

- `Endpoint`
- `NetworkDispatcher`
- `URLSessionNetworkDispatcher`
- `NetworkError`

The Home feature defines:

- `HomeEndpoint`
- `HomeNetworkServicing`
- `HomeNetworkManager`

Random User API endpoint:

```text
GET https://randomuser.me/api?results={count}
```

### Local Storage

Core Data files are under `Core/LocalStorage/CoreData`.

The Home list storage layer contains:

- `HomeListManager`
- `HomeListRepository`
- `ProfileModel`
- `ProfileInfo` Core Data entity files

Fetched API profiles are mapped into local `ProfileModel` values for SwiftUI rendering.

### Presentation

Home presentation files:

- `HomeScreenViewModel`
- `HomeScreen`
- `HomeUserCardView`
- `HomeUsersResponse`

`HomeScreenViewModel` is `@MainActor`, owns the screen state, fetches users through `HomeNetworkServicing`, and coordinates saving/fetching local profiles through `HomeListManageable`.

## Dependencies

The project uses Swift Package dependencies:

- `SDWebImage`
- `SDWebImageSwiftUI`

No third-party networking dependency is used.

## Requirements

- Xcode 15 or newer
- iOS 15+
- Swift 5.9+

## Setup

1. Clone the repository.
2. Open `PeopelInteractiveAssessDeveshPandeyIOS.xcodeproj` in Xcode.
3. Let Xcode resolve Swift Package dependencies.
4. Select the app scheme.
5. Build and run on an iOS simulator or device.

## Notes

- The app uses `ObservableObject` and `@Published` for iOS 15 compatibility.
- Network calls use Swift async/await.
- Core Data write work is performed through background contexts.
- The current Home list uses local Core Data results as the UI source of truth.

## Testing

The test target includes `MockNetworkDispatcher` for injecting success and failure responses into networking-dependent code.

Run tests from Xcode with:

```text
Product > Test
```
