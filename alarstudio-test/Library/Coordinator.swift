//
//  Coordinator.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//


class BaseCoordinator {
    
    private weak var parent: BaseCoordinator?
    private var children: [BaseCoordinator] = []
    
    func coordinate(to coordinator: BaseCoordinator) {
        coordinator.parent = self
        children.append(coordinator)
        coordinator.start()
    }
    
    func start() {
        print("\(name) did start")
    }
    
    func complete() {
        parent?.remove(coordinator: self)
        print("\(name) did complete")
    }
    
    var onComplete: Void = () {
        didSet { complete() }
    }
    
    // MARK: - Private
    
    private func remove(coordinator: BaseCoordinator) {
        if let index = children.firstIndex(where: { $0 === coordinator}) {
            children.remove(at: index)
        }
        coordinator.parent = nil
    }
    
    private var name: String {
        String(describing: type(of: self))
    }
}
