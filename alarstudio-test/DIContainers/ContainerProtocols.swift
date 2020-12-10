//
//  ContainerProtocols.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//
// A container that is unlocked when the app starts:


struct ContainerBuilder {
    let auth: () -> AuthContainerProtocol
    let countries: (AuthToken) -> CountriesContainer
}


protocol AuthContainerProtocol {
    var authService: AuthService { get }
}

protocol CountriesContainerProtocol {
    
    var countriesService: CountriesService { get }
    
    init(authToken: AuthToken)
}
