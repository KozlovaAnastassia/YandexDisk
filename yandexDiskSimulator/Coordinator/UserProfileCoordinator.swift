//
//  UserProfileCoordinator.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import UIKit

final class UserProfileCoordinator: Coordinator {
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    private var modalNavigationController: UINavigationController?
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .userProfileTab }
    
    weak var parentCoordinator: Coordinator?
    
    func start() {
        let userProfileViewController = UserProfileViewController()
        let userProfileViewModel = UserProfileViewModel()
        userProfileViewController.viewModel = userProfileViewModel
        userProfileViewModel.coordinator = self
        userProfileViewModel.didSendEventClosure = {
            [weak self] event in
            self?.parentCoordinator?.finish()
        }
        navigationController.pushViewController(userProfileViewController, animated: true)
    }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showPublishedFiles() {
            let publishedFilesViewController = PublishedFilesViewController()
            let serviceViewModel = PublishedFilesViewModel()
            serviceViewModel.coordinator = self
            publishedFilesViewController.serviceViewModel = serviceViewModel
            navigationController.pushViewController(publishedFilesViewController, animated: true)
    }
    
    
    //MARK: Navigate to WebViewViewController
    
    func showWebViewDetailViewController(with viewModeltoDisplay: TableViewCellViewModel) {
        self.modalNavigationController = UINavigationController()
        modalNavigationController?.modalTransitionStyle = .flipHorizontal
        modalNavigationController?.modalPresentationStyle = .fullScreen
        
        let webViewDetailViewController = WebViewDetailViewController()
        
        modalNavigationController?.setViewControllers([webViewDetailViewController], animated: false)
        
        let lastUploadedDetailViewModel = DetailViewControllerViewModel()
        
        lastUploadedDetailViewModel.cellViewModel = viewModeltoDisplay
        webViewDetailViewController.viewModel = lastUploadedDetailViewModel
        
        lastUploadedDetailViewModel.coordinator = self
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
    }
    
    //MARK: Navigate to ImageViewViewController
    
    func showImageDetailViewController(with viewModeltoDisplay: TableViewCellViewModel) {
        self.modalNavigationController = UINavigationController()
        modalNavigationController?.modalTransitionStyle = .flipHorizontal
        modalNavigationController?.modalPresentationStyle = .fullScreen
      
        let imageViewDetailViewController =
        ImageViewDetailViewController()
        
        let lastUploadedDetailViewModel = DetailViewControllerViewModel()
        
        
        modalNavigationController?.setViewControllers([imageViewDetailViewController], animated: false)
        lastUploadedDetailViewModel.cellViewModel = viewModeltoDisplay
        
        imageViewDetailViewController.viewModel = lastUploadedDetailViewModel
        
        lastUploadedDetailViewModel.coordinator = self
        
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }

    }
    
    //MARK: Navigate to PDFViewViewController
    
    func showPDFViewDetailViewController(with viewModeltoDisplay: TableViewCellViewModel) {
        self.modalNavigationController = UINavigationController()
        modalNavigationController?.modalTransitionStyle = .flipHorizontal
        modalNavigationController?.modalPresentationStyle = .fullScreen
        let pdfViewDetailViewController = PDFViewDetailViewController()
        modalNavigationController?.setViewControllers([pdfViewDetailViewController], animated: false)
        let lastUploadedDetailViewModel = DetailViewControllerViewModel()
        lastUploadedDetailViewModel.cellViewModel = viewModeltoDisplay
        pdfViewDetailViewController.viewModel = lastUploadedDetailViewModel
        lastUploadedDetailViewModel.coordinator = self
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
        
    }
    
    //MARK: Navigate to UnknownViewController
    
    func showUnknowDetailViewController(with viewModeltoDisplay: TableViewCellViewModel) {
        let unknownDetailViewController = UnknownDetailViewController()
        let lastUploadedDetailViewModel = DetailViewControllerViewModel()
        lastUploadedDetailViewModel.cellViewModel = viewModeltoDisplay
        unknownDetailViewController.viewModel = lastUploadedDetailViewModel
        lastUploadedDetailViewModel.coordinator = self
        navigationController.pushViewController(unknownDetailViewController, animated: true)
    }
    
    //MARK: Navigate to folder content
    
    func showDirectoryViewController(with viewModeltoDisplay: TableViewCellViewModel) {
        let publishedFolderViewController = PublishedFolderViewController()
        publishedFolderViewController.dataViewModel = viewModeltoDisplay
        let publishedViewModel = PublishedFilesViewModel()
        publishedViewModel.coordinator = self
        publishedFolderViewController.publishedFilesViewModel = publishedViewModel
        navigationController.pushViewController(publishedFolderViewController, animated: true)
    }
    
}
