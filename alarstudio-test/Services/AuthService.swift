//
//  AuthService.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//
import Foundation
import Combine





typealias RealAuthService = ProdAuthService

class ProdAuthService: AuthService {
    
    
    private let dataFetcher: DataFetcherService = DataFetcherService()
    
    
    func authenticate(login: String, password: String, completion: @escaping (AuthResponse?) -> Void) {
        dataFetcher.authenticate(login: login, password: password, completion: completion)
    }

}

#if DEBUG

class TempraryAuthService: AuthService {

    func authenticate(login: String, password: String, completion: @escaping (AuthResponse?) -> Void) {
        let response = AuthResponse(status: "ok", code: "8823007966")
        completion(response)
    }
    
}

#endif


