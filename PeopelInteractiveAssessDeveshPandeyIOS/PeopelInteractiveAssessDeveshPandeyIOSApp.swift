import SwiftUI

@main
struct PeopelInteractiveAssessDeveshPandeyIOSApp: App {
    
    private let coordinator = ApplicationCoordinator(dependencyBox: AppDependencyContainer())

    var body: some Scene {
        WindowGroup {
            NavigationControllerHost(navigationController: coordinator.navigationController)
                .onAppear {
                    coordinator.start()
                }
        }
    }
}
