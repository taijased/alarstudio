//
//  MapViewCoordinator.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 10.12.2020.
//



import UIKit
import Combine

final class MapViewCoordinator: BaseCoordinator {
    
    private let container: CountriesContainer
    private weak var parent: UIViewController?
    private let country: Country
    private var cancelBag = CancelBag()
    
    init(container: CountriesContainer, parent: UIViewController, country: Country) {
        self.container = container
        self.parent = parent
        self.country = country
    }
    
    override func start() {
        super.start()
        guard let parent = parent else { return }
        let viewModel = MapViewModel(container: container, country: country)
        let viewController = MapViewController(viewModel: viewModel)
        parent.present(viewController, animated: true, completion: nil)
        cancelBag.collect {
            viewModel.onClose
                .sink { [weak viewController] in
                    viewController?.dismiss(animated: true, completion: nil)
                }
            viewModel.onFinish
                .assign(to: \.onComplete, on: self)
        }
    }
}
