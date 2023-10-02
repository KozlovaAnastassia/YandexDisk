//
//  TabCoordinator.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import UIKit

enum TabBarPage {
    case profile
    case lastUploaded
    case allFiles

    init?(index: Int) {
        switch index {
        case 0:
            self = .profile
        case 1:
            self = .lastUploaded
        case 2:
            self = .allFiles
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .profile:
            return Constants.Text.pageTitleProfile
        case .lastUploaded:
            return  Constants.Text.pageTitleLastUploaded
        case .allFiles:
            return Constants.Text.pageTitleAllFiles
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .profile:
            return 0
        case .lastUploaded:
            return 1
        case .allFiles :
            return 2
        }
    }

    
    func pageTabIcon() -> UIImage {
            switch self {
            case .profile:
                return UIImage(systemName: "person") ?? UIImage()
            case .lastUploaded:
                return UIImage(systemName: "doc") ?? UIImage()
            case .allFiles :
                return UIImage(systemName: "archivebox") ?? UIImage()
            }
    }
    
}


protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
}

final class TabCoordinator: NSObject, Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
        
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController
    
    var tabBarController: UITabBarController

    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }

    func start() {
        // define which pages do we want to add into tab bar
        let pages: [TabBarPage] = [.profile, .lastUploaded, .allFiles]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
    
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    deinit {
        print("TabCoordinator deinit")
    }

    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabControllers, animated: false)
        tabBarController.selectedIndex = TabBarPage.lastUploaded.pageOrderNumber()
        let appearance = UITabBarAppearance()
        tabBarController.tabBar.standardAppearance = appearance
        navigationController.viewControllers = [tabBarController]
    }
      
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)
        
        navController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                                     image: page.pageTabIcon(),
                                                     tag: page.pageOrderNumber())

        switch page {
        case .profile:
            // If needed: Each tab bar flow can have it's own Coordinator.
            let userProfileCoordinator = UserProfileCoordinator(navController)
            userProfileCoordinator.parentCoordinator = self
            userProfileCoordinator.start()
        case .lastUploaded:
            let lastUploadedCoordinator = LastUploadedCoordinator(navController)
            lastUploadedCoordinator.start()
        case .allFiles:
            let allFilesCoordinator = AllFilesCoordinator(navController)
            allFilesCoordinator.start()
        }
        
        return navController
    }
    
    func currentPage() -> TabBarPage? { TabBarPage.init(index: tabBarController.selectedIndex) }

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
}

// MARK: - UITabBarControllerDelegate
extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        // Some implementation
        
    }
}
