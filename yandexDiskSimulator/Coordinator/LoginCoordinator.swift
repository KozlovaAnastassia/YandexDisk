//
//  LoginCoordinator.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import UIKit

protocol LoginCoordinatorProtocol: Coordinator {
    func goToOnboarding()
    func goToAuthPage()
}

final class LoginCoordinator: LoginCoordinatorProtocol {
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType {
        return .login
    }
    
    func start() {
        showEnterViewController()
    }
    
    deinit {
        print("LoginCoordinator deinit")
    }
    
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showEnterViewController() {
        let enterViewController = LoginViewController()
        let enterViewModel = LoginViewModel()
        enterViewModel.coordinator = self
        enterViewController.viewModel = enterViewModel
        navigationController.setViewControllers([enterViewController], animated: false)
    }
    
    func goToOnboarding() {
        let demoViewController = DemoViewController()
        let demoViewModel = DemoViewModel()
        demoViewModel.coordinator = self
        demoViewController.viewModel = demoViewModel
        navigationController.pushViewController(demoViewController, animated: true)
    }

    func goToAuthPage() {
        let authViewController = AuthViewController()
        let authViewModel = AuthViewModel()
        authViewModel.coordinator = self
        authViewController.viewModel = authViewModel
        authViewModel.didSendEventClosure = {
            [weak self] event in
                self?.finish()
        }
        navigationController.pushViewController(authViewController, animated: true)
    }
}
