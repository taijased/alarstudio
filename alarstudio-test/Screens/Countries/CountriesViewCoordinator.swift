//
//  CountriesViewCoordinator.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//


import UIKit
import Combine

final class CountriesViewCoordinator: BaseCoordinator {
    
    private let container: CountriesContainer
    private weak var parent: UIViewController?
    private weak var viewController: UIViewController?
    private var cancelBag = CancelBag()
    let endUserSession = PassthroughSubject<Void, Never>()
    
    init(container: CountriesContainer, parent: UIViewController) {
        self.container = container
        self.parent = parent
    }
    
    override func start() {
        super.start()
        guard let parent = parent else { return }
        let viewModel = CountriesViewModel(container: container)
        
        cancelBag.collect {
            viewModel.onSelect.sink { [weak self] country in
                self?.coordinateMap(country)
            }
            viewModel.onLogOut
                .subscribe(endUserSession)
            endUserSession
                .assign(to: \.onComplete, on: self)
        }
        
        let viewController = CountriesViewController(viewModel: viewModel)
        self.viewController = viewController
        parent.setContentViewController(viewController)
    }
 
    
    
    override func complete() {
        super.complete()
        guard let vc = self.parent?.children
            .compactMap({ $0 as? CountriesViewController })
            .first else { return }
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    
    
    private func coordinateMap(_ country: Country) {
        guard let viewController = viewController else { return }
        
        let coordinator = MapViewCoordinator(
            container: container, parent: viewController, country: country)
        self.coordinate(to: coordinator)
    }
    
    
}
