import UIKit

@MainActor
protocol ApplicationCoordinating: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [any ApplicationCoordinating] { get set }

    func start()
}
