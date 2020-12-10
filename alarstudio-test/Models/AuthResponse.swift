//
//  AuthResponse.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//

import Foundation


struct AuthToken: Hashable, Codable {
    let value: String
}



struct AuthResponse: Codable {
    let status, code: String
    
    func isStatus() -> Bool {
        return status == "ok"
    }
}
