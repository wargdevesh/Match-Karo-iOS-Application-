import SwiftUI
import UIKit

struct NavigationControllerHost: UIViewControllerRepresentable {
    let navigationController: UINavigationController

    func makeUIViewController(context: Context) -> UINavigationController {
        navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
