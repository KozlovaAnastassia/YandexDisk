//
//  DemoViewModel.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import Foundation
final class DemoViewModel {
    
    var coordinator: LoginCoordinator?
    
    func showAuthPage() {
        coordinator?.goToAuthPage()
    }
}
