//
//  AuthViewCoordinator.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//

import UIKit
import Combine

final class AuthViewCoordinator: BaseCoordinator {
    
    private let container: AuthContainerProtocol
    private weak var parent: UIViewController?
    private var cancelBag = CancelBag()
    let startUserSession = PassthroughSubject<AuthToken, Never>()
    
    init(container: AuthContainerProtocol, parent: UIViewController) {
        self.container = container
        self.parent = parent
    }
    
    override func start() {
        super.start()
        guard let parent = parent else { return }
        let viewModel = AuthViewModel(container: container)
        cancelBag.collect {
            viewModel.$progress
                .map(\.status)
                .compactMap { $0.value }
                .subscribe(startUserSession)
            startUserSession.first()
                .map { _ in () }
                .assign(to: \.onComplete, on: self)
        }
        
        let viewController = AuthViewController(viewModel: viewModel)
        parent.setContentViewController(viewController)
    }
    
    override func complete() {
        super.complete()
        guard let vc = self.parent?.children
            .compactMap({ $0 as? AuthViewController })
            .first else { return }
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
}
