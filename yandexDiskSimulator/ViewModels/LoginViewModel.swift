//
//  LoginViewModel.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import Foundation


final class LoginViewModel {
    
    let defaults = UserDefaults.standard
    var coordinator: LoginCoordinator?
    
    func isAppAlreadyLaunchedOnce() -> Bool {
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil {
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
    }
    
    func enterButtonPressed() {
        if !isAppAlreadyLaunchedOnce() {
            coordinator?.goToOnboarding()
        } else if KeychainManager.shared.getTokenFromKeychain() == nil {
            
            coordinator?.goToAuthPage()
        } else {
             coordinator?.finish()
        }
    }
    
}
