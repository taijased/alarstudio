//
//  CountriesModel.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 10.12.2020.
//

import Foundation

// MARK: - CountriesResponse
struct CountriesResponse: Codable {
    let status: String
    let page: Int?
    let data: [Country]?
 
}

// MARK: - Country
struct Country: Codable, Identifiable {
    let id, name, country: String
    let lat, lon: Double
    
    
    static let example: Country = Country(id: "KLAL", name: "LAKELAND LINDER RGNL", country: "United States of America", lat:  27.988916666666668, lon: -82.01855555555555)
}
