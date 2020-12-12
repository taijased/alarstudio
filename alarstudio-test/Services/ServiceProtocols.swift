//
//  ServiceProtocols.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//



protocol AuthService {
    func authenticate(login: String, password: String, completion: @escaping (AuthResponse?) -> Void)
}




protocol CountriesService {
    func fetchCountries(page: Int, completion: @escaping ([Country]?) -> Void)
}


