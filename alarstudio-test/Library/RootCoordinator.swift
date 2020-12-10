//
//  RootCoordinator.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//


import UIKit

final class RootCoordinator: BaseCoordinator {
    
    private lazy var window = UIWindow(frame: UIScreen.main.bounds)
    private lazy var rootVC = UIViewController()
    private let containerBuilder: ContainerBuilder
    private var cancelbag = CancelBag()
    
    init(containerBuilder: ContainerBuilder) {
        self.containerBuilder = containerBuilder
    }
    
    override func start() {
        super.start()
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        
        if let receivedData = KeyChain.load(key: "token") {
            let result = String(decoding: receivedData, as: UTF8.self)
            print(result)
            coordinate(to: .home(result))
        } else {
            coordinate(to: .auth)
        }

    }
    
    
    private func coordinate(to: Coordinate) {
        switch to {
        case .auth:
            coordinateToAuth()
        case .home(let token):
            coordinateCountries(authToken: AuthToken(value: token))
        }
    }
    
    
    private func coordinateToAuth() {
        let container = containerBuilder.auth()
        let loginCoordinator = AuthViewCoordinator(container: container, parent: rootVC)
        loginCoordinator.startUserSession
            .first()
            .sink { [weak self] authToken in
                self?.coordinateCountries(authToken: authToken)
            }
            .store(in: &cancelbag)
        coordinate(to: loginCoordinator)
    }
    
    private func coordinateCountries(authToken: AuthToken) {
        let container = containerBuilder.countries(authToken)
        
        let sessionCoordinator = CountriesViewCoordinator(container: container, parent: rootVC)
        sessionCoordinator.endUserSession
            .first()
            .sink { [weak self] _ in
                self?.coordinateToAuth()
            }
            .store(in: &cancelbag)
        coordinate(to: sessionCoordinator)
    }
    
}



extension RootCoordinator {
    enum Coordinate {
        case auth
        case home(String)
    }
}

