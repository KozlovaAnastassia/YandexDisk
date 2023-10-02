//
//  AllFilesCoordinator.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import UIKit

final class AllFilesCoordinator: Coordinator {
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    private var modalNavigationController: UINavigationController?
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .lastUploadedTab }
    
    
    func start() {
        let allFilesViewController = AllFilesViewController()
        let allFilesViewModel = AllFilesViewModel()
        allFilesViewController.viewModel = allFilesViewModel
        allFilesViewModel.coordinator = self
        navigationController.pushViewController(allFilesViewController, animated: true)
    }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
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
        let folderViewController = FolderViewController()
        folderViewController.dataViewModel = viewModeltoDisplay
        let serviceViewModel = AllFilesViewModel()
        serviceViewModel.coordinator = self
        folderViewController.allFilesViewModel = serviceViewModel
        navigationController.pushViewController(folderViewController, animated: true)
    }
    
    
    
    
}
