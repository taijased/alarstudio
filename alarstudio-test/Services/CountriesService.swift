//
//  CountriesService.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 10.12.2020.
//




typealias RealCountriesService = WebCountriesService




final class WebCountriesService: CountriesService {
    
    
    
    
    private let dataFetcher: DataFetcherService
    private let token: AuthToken
    
    required init(token: AuthToken) {
        self.token = token
        self.dataFetcher = DataFetcherService(token: token)
        print(token)
    }
    
    
    
    func fetchCountries(page: Int, completion: @escaping ([Country]?) -> Void) {
        dataFetcher.fetchCountries(page: page) { (response) in
            
            
            
            guard
                let countries = response?.data
            else {
                completion(nil)
                
                return
            }
            completion(countries)
        }
    }
}





#if DEBUG
class TempraryCountriesService: CountriesService {


    private let token: AuthToken

    required init(token: AuthToken) {
        self.token = token
    }

    func fetchCountries(page: Int, completion: @escaping ([Country]?) -> Void) {
        let temp = [
            Country.example,
            Country.example,
            Country.example,
            Country.example,
        ]
        completion(temp)
    }
}
#endif
