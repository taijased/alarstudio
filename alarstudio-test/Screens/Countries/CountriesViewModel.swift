//
//  CountriesViewModel.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//

import Combine

final class CountriesViewModel: ObservableObject {
    let onSelect = PassthroughSubject<Country, Never>()
    let onLogOut = PassthroughSubject<Void, Never>()
    
    @Published var countries = [Country]()
    @Published var status: Status = Status.notRequested(nextPage: 1)
    
    private let countriesService: CountriesService
    private var cancelBag = Set<AnyCancellable>()
    
    init(container: CountriesContainerProtocol) {
        self.countriesService = container.countriesService
    }
    
}




extension CountriesViewModel {
    func loadContent() {

        guard case let .notRequested(page) = status else {
            return
        }
        status = .loading(page: page)
        
        countriesService.fetchCountries(page: page) { countries in
        
            guard
                let countries = countries
            else {
                self.clearKeyChain()
                self.logOut();
                return
            }
            
            self.countries.append(contentsOf: countries)
            
            if countries.count == 0 {
                // not more pages
                self.status = .done
            } else {
                
                guard case let .loading(page) = self.status else {
                    fatalError("same error with status")
                }
                
                self.status = .notRequested(nextPage: page + 1)
            }
        }
    }
    
    func loadMore(_ currentItem: Country? = nil) {
        guard let currentItem = currentItem else { return }
        if countries.count >= 0 && currentItem.id == countries[countries.count - 1].id {
            self.loadContent()
        }
    }
    
    func select(country: Country) {
        guard let selectItem = countries.first(where: { $0.id == country.id }) else { return }
        onSelect.send(selectItem)
    }
    
    func logOut() {
        onLogOut.send(())
    }
    
    fileprivate func clearKeyChain() {
        KeyChain.clear()
    }
    
}


extension CountriesViewModel {
    
    enum Status {
        case notRequested(nextPage: Int)
        case loading(page: Int)
        case done
    }
}
