//
//  DataFetcherService.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//

import Foundation

class DataFetcherService {
    
    var dataFetcher: DataFetcher
    private var token: AuthToken?
    
    private let baseURL: String = "https://www.alarstudios.com/test/"
    
    init(dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.dataFetcher = dataFetcher
    }
    
    
    
    
    init(dataFetcher: DataFetcher = NetworkDataFetcher(), token: AuthToken) {
        self.dataFetcher = dataFetcher
        self.token = token
    }
    
    
    
    func authenticate(login: String, password: String, completion: @escaping (AuthResponse?) -> Void) {
        let urlString = baseURL + "auth.cgi?username=\(login)&password=\(password)"
        dataFetcher.fetchGenericJSONData(urlString: urlString, response: completion)
    }
    
    
    
    func fetchCountries(page: Int, completion: @escaping (CountriesResponse?) -> Void) {
        guard let token = token?.value else { completion(nil); return }
        let urlString = baseURL + "data.cgi?code=\(token)&p=\(page)"
        
        dataFetcher.fetchGenericJSONData(urlString: urlString, response: completion)
    }
    
    
    
}
