//
//  CountriesContainer.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 10.12.2020.
//

import Foundation



struct CountriesContainer: CountriesContainerProtocol {
    
    let countriesService: CountriesService
    
    init(authToken: AuthToken) {
        self.countriesService = RealCountriesService(token: authToken)
    }
}



#if DEBUG

struct TempraryCountriesContainer: CountriesContainerProtocol {
    
    let countriesService: CountriesService
    
    init(authToken: AuthToken = AuthToken(value: "temp-2132323")) {
        self.countriesService = TempraryCountriesService(token: authToken)
    }
}

#endif
