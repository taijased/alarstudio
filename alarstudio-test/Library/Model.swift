//
//  Model.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//

import Foundation


struct User: Hashable, Codable {
    let name: String
    let balance: Int
}

struct Transaction: Hashable, Codable {
    let id: String
    let date: Date
    let amount: Int
    let description: String
}
