//
//  LoginViewController.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    var viewModel: LoginViewModel?
    
    private let enterView: LoginView = {
        let view = LoginView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
        
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(enterView)
        
        enterView.onButtonTap = { [weak self] in
            self?.viewModel?.enterButtonPressed()
        }
        
        NSLayoutConstraint.activate([
            enterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            enterView.topAnchor.constraint(equalTo: view.topAnchor),
            enterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            enterView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}
