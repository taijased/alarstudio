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
    
    @Published var countries: [Country] = []
    
    private var page: Int = 1
    
    private let countriesService: CountriesService
    private var cancelBag = Set<AnyCancellable>()
    
    init(container: CountriesContainerProtocol) {
        self.countriesService = container.countriesService
    }
    
}




extension CountriesViewModel {
    func loadContent() {

        countriesService.fetchCountries(page: page) { countries in
            guard
                let countries = countries
            else {
                self.clearKeyChain()
                self.logOut();
                return
            }
            self.countries.append(contentsOf: countries)
            self.page+=1
        }

    }
    
    func loadNextPage(_ country: Country) {
  
        guard let lastItem = self.countries.last  else { return }
        
        if lastItem.id == country.id {
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
