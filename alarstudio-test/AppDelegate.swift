//
//  AppDelegate.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var rootCoordinator: BaseCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let builder = ContainerBuilder(
            auth: { AuthContainer() },
            countries: { authToken in
                CountriesContainer(authToken: authToken)
            })
        
        rootCoordinator = RootCoordinator(containerBuilder: builder)
        rootCoordinator?.start()
        return true
    }
}
