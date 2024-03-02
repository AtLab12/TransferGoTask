//
//  ConverterViewModel.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 01/03/2024.
//

import Foundation
import UIKit

@Observable
final class ConverterViewModel {
    
    public var fromAmount: String
    public var fromCurrency: Currency
    public var toAmount: String
    public var toCurrency: Currency
    
    init() {
        self.fromAmount = "100.00"
        self.fromCurrency = .init(acronym: "PLN", flag: UIImage(resource: .plImg), id: UUID(), sendingLimit: 20000, country: "Poland", fullName: "Polish zloty")
        self.toAmount = "0.0"
        self.toCurrency = .init(acronym: "UAH", flag: UIImage(resource: .uaImg), id: UUID(), sendingLimit: 50000, country: "Ukraine", fullName: "Hrivna")
    }
    
    func swapCurrencies() {
        (fromCurrency, fromAmount, toCurrency, toAmount) = (toCurrency, toAmount, fromCurrency, fromAmount)
    }
}
