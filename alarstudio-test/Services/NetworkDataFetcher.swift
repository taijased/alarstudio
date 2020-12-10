//
//  NetworkDataFetcher.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//


import Foundation

protocol DataFetcher {
    func fetchGenericJSONData<T: Decodable>(urlString: String, response: @escaping(T?) -> Void)
}

class NetworkDataFetcher: DataFetcher{
    
    var networking: Networking
    
    init(networking: Networking = NetworkService()) {
        self.networking = networking
    }
    
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, response: @escaping(T?) -> Void) {
        networking.request(urlString: urlString) { (data, error) in
            if let error = error {
                print("Failed  received requesting data", error)
                response(nil)
            }
            let decoded = self.decodeJSON(type: T.self, from: data)
            response(decoded)
        }
    }
    
    
    
    fileprivate func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
            
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
