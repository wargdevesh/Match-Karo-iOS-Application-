import SwiftUI
import UIKit

@MainActor
final class HomeFlowCoordinator: ApplicationCoordinating {
    let navigationController: UINavigationController
    var childCoordinators: [any ApplicationCoordinating] = []
    var dependecyBox: any HomeFlowDependencies

    init(navigationController: UINavigationController,dependencyBox: HomeFlowDependencies) {
        self.navigationController = navigationController
        self.dependecyBox = dependencyBox
    }

    func start() {
        let viewModel = HomeScreenViewModel(networkManager: dependecyBox.makeHomeNetworkManager(),homeListManager: dependecyBox.makeHomeListManager())
        let homeScreen = HomeScreen(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: homeScreen)
        hostingController.title = "Profiles Around You"

        navigationController.setViewControllers([hostingController], animated: false)
    }
}
