//
//  AuthViewController.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import UIKit
import WebKit


final class AuthViewController: UIViewController {
    
    var viewModel: AuthViewModel?
   

    private let scheme = "myfiles"
    
    private let webView = WKWebView()
    
    private let clientId: String = "d236e36b801346798d07d9a6e663fe8e"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.clean()

        setupViews()
        setupLayout()

        guard let request = viewModel?.request else { return }
        DispatchQueue.main.async { [weak self] in
            self?.webView.load(request)
        }
        webView.navigationDelegate = viewModel


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(webView)
        
    }
    
    private func setupLayout() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            webView.topAnchor.constraint(equalTo: margins.topAnchor),
            webView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    deinit {
        print("AuthViewController deinit")
    }
    
}

