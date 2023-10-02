//
//  AuthViewModel.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import Foundation
import WebKit

final class AuthViewModel: NSObject {
    
    var coordinator: LoginCoordinator?
    
    var didSendEventClosure: ((AuthViewModel.Event) -> Void) = {_ in }
    
    enum Event {
        case login
    }
    private let scheme = "myfiles"

    private let clientId: String = "d236e36b801346798d07d9a6e663fe8e"

    var request: URLRequest? {

        guard var urlComponents = URLComponents(string: "https://oauth.yandex.ru/authorize") else { return nil }

        urlComponents.queryItems = [
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "client_id", value: "\(clientId)")
        ]
        guard let url = urlComponents.url else { return nil}
        return URLRequest(url: url)
    }
    
}


extension AuthViewModel: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == scheme {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }
            
            let token = components.queryItems?.first(where: { $0.name == "access_token"})?.value
            
            if let token = token {
         
                KeychainManager.shared.saveTokenInKeychain(token)
            }
            didSendEventClosure(.login)
        }
        decisionHandler(.allow)
    }
}
