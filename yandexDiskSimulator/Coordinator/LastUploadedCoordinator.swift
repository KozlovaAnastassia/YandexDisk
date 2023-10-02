//
//  LastUploadedCoordinator.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import UIKit

final class LastUploadedCoordinator: Coordinator {
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    private var modalNavigationController: UINavigationController?
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .lastUploadedTab }
    
    
    func start() {
        let lastUploadedVC = LastUploadedViewController()
        let lastUploadedViewModel = LastUploadedViewModel()
        lastUploadedVC.viewModel = lastUploadedViewModel
        lastUploadedViewModel.coordinator = self
        navigationController.pushViewController(lastUploadedVC, animated: true)
    }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: Online Navigation Methods
    
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
//        navigationController.pushViewController(webViewDetailViewController, animated: true)
    }
    

    
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
//        navigationController.pushViewController(imageViewDetailViewController, animated: true)
    }
    

    
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
        
//        navigationController.pushViewController(pdfViewDetailViewController, animated: true)
    }

    
    func showUnknowDetailViewController(with viewModeltoDisplay: TableViewCellViewModel) {
        let unknownDetailViewController = UnknownDetailViewController()
        let lastUploadedDetailViewModel = DetailViewControllerViewModel()
        lastUploadedDetailViewModel.cellViewModel = viewModeltoDisplay
        unknownDetailViewController.viewModel = lastUploadedDetailViewModel
        lastUploadedDetailViewModel.coordinator = self
        navigationController.pushViewController(unknownDetailViewController, animated: true)
    }
    
    
//    MARK: - Offline Navigation Methods
    
    func offlineShowImageDetailViewController(with offlineViewModel: YandexDiskItem) {
        self.modalNavigationController = UINavigationController()
        modalNavigationController?.modalTransitionStyle = .flipHorizontal
        modalNavigationController?.modalPresentationStyle = .fullScreen
      
        let imageViewDetailViewController =
        ImageViewDetailViewController()
        
        let lastUploadedDetailViewModel = DetailViewControllerViewModel()
        
        modalNavigationController?.setViewControllers([imageViewDetailViewController], animated: false)
        
        lastUploadedDetailViewModel.offlineModel = offlineViewModel
        
        imageViewDetailViewController.viewModel = lastUploadedDetailViewModel
        
        lastUploadedDetailViewModel.coordinator = self
        
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
    }
    
    
    
    func offlineShowWebViewDetailViewController(with offlineViewModel: YandexDiskItem) {
        self.modalNavigationController = UINavigationController()
        modalNavigationController?.modalTransitionStyle = .flipHorizontal
        modalNavigationController?.modalPresentationStyle = .fullScreen
        
        let webViewDetailViewController = WebViewDetailViewController()
        
        modalNavigationController?.setViewControllers([webViewDetailViewController], animated: false)
        
        let lastUploadedDetailViewModel = DetailViewControllerViewModel()
        
        lastUploadedDetailViewModel.offlineModel = offlineViewModel
        
        webViewDetailViewController.viewModel = lastUploadedDetailViewModel
        
        lastUploadedDetailViewModel.coordinator = self
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
    }
    
    
    
    func offlineShowPDFViewDetailViewController(with offlineViewModel: YandexDiskItem) {
        self.modalNavigationController = UINavigationController()
        modalNavigationController?.modalTransitionStyle = .flipHorizontal
        modalNavigationController?.modalPresentationStyle = .fullScreen
        
        let pdfViewDetailViewController = PDFViewDetailViewController()
        
        modalNavigationController?.setViewControllers([pdfViewDetailViewController], animated: false)
        
        let lastUploadedDetailViewModel = DetailViewControllerViewModel()
        
        lastUploadedDetailViewModel.offlineModel = offlineViewModel
        
        pdfViewDetailViewController.viewModel = lastUploadedDetailViewModel
        
        lastUploadedDetailViewModel.coordinator = self
        
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
    }
    
    
    func offlineShowUnknowDetailViewController(with offlineViewModel: YandexDiskItem) {
        let unknownDetailViewController = UnknownDetailViewController()
        let lastUploadedDetailViewModel = DetailViewControllerViewModel()
        lastUploadedDetailViewModel.offlineModel = offlineViewModel
        unknownDetailViewController.viewModel = lastUploadedDetailViewModel
        lastUploadedDetailViewModel.coordinator = self
        navigationController.pushViewController(unknownDetailViewController, animated: true)
    }
    
    
}
