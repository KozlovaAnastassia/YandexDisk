//
//  AppDelegate.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import UIKit
import SDWebImageSVGCoder

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    let SVGCoder = SDImageSVGCoder.shared
   

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SDImageCodersManager.shared.addCoder(SVGCoder)
        
        if #available(iOS 13.0, *) {
            let standartAppearence = UINavigationBarAppearance()
            standartAppearence.configureWithDefaultBackground()

            let backButtonAppearence = UIBarButtonItemAppearance()
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
            backButtonAppearence.normal.titleTextAttributes = titleTextAttributes
            backButtonAppearence.highlighted.titleTextAttributes = titleTextAttributes
            standartAppearence.backButtonAppearance = backButtonAppearence

            UINavigationBar.appearance().standardAppearance = standartAppearence
            UINavigationBar.appearance().compactAppearance = standartAppearence
            UINavigationBar.appearance().scrollEdgeAppearance = standartAppearence

        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationCon = UINavigationController()
        window?.rootViewController = navigationCon
        window?.makeKeyAndVisible()
        appCoordinator = AppCoordinator(navigationCon)
        appCoordinator?.start()
        
        return true
    }

    func delay(delay: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            completion()
        })
    }
    
}

