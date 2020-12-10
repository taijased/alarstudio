//
//  Formatters.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//


import Foundation

extension NumberFormatter {
    static var currency: NumberFormatter {
        let currencyFormatter = NumberFormatter()
        let locale = Locale.USA
        currencyFormatter.locale = locale
        currencyFormatter.currencySymbol = locale.currencySymbol
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = .current
        return currencyFormatter
    }
    
    func amount(cents: Int) -> String {
        string(from: .amount(cents:cents)) ?? ""
    }
}

extension DateFormatter {
    static var transaction: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .USA
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
}

extension Locale {
    static var USA: Locale {
        return Locale(identifier: "en_US")
    }
}

extension NSNumber {
    static func amount(cents: Int) -> NSNumber {
        return NSDecimalNumber(value: cents)
            .dividing(by: NSDecimalNumber(value: 100))
    }
}
