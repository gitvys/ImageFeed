//
//  SplashScreenController.swift
//  ImageFeed
//
//  Created by Vladislav Sokolov on 12.04.2025.
//

import UIKit

final class SplashScreenController: UIViewController {
    private let storage = OAuth2TokenStorage.shared
    private let showAuthenticationScreenSegueIdentifier = "showAuthScreen"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear вызван")
        
        if storage.token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
//        print("Переключение на TabBarController")
    }
}

extension SplashScreenController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashScreenController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        print("Авторизация успешна, переключаемся на TabBarController")
        navigationController?.popViewController(animated: true)
        self.switchToTabBarController()
    }
}
