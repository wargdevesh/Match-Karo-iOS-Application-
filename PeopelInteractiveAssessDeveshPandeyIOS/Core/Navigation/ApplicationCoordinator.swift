import UIKit

@MainActor
final class ApplicationCoordinator: ApplicationCoordinating {
    let navigationController: UINavigationController
    var childCoordinators: [any ApplicationCoordinating] = []
    
    var dependecyBox: AppDependencyContainer

    private var hasStarted = false

    init(dependencyBox: AppDependencyContainer) {
        self.dependecyBox = dependencyBox
        self.navigationController = AppNavigationController()
        configureNavigationBar()
    }

    init(navigationController: UINavigationController,dependencyBox: AppDependencyContainer) {
        self.dependecyBox = dependencyBox
        self.navigationController = navigationController
        configureNavigationBar()
    }

    func start() {
        guard !hasStarted else { return }
        hasStarted = true

        let homeFlowCoordinator = HomeFlowCoordinator(navigationController: navigationController,dependencyBox: dependecyBox)
        childCoordinators.append(homeFlowCoordinator)
        homeFlowCoordinator.start()
    }

    private func configureNavigationBar() {
        navigationController.view.backgroundColor = .black
        navigationController.navigationBar.tintColor = .white

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
    }
}
