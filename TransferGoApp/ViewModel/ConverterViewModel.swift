//
//  ConverterViewModel.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 01/03/2024.
//

import Foundation
import UIKit
import Combine

@Observable
final class ConverterViewModel {
    
    public var fromAmount: String
    public var fromCurrency: Currency
    public var toAmount: String
    public var toCurrency: Currency
    public private(set) var rate: Double
    public private(set) var error: Error?
    
    public var rateLabel: String {
        "1 \(fromCurrency.acronym) = \(rate) \(toCurrency.acronym)"
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.fromAmount = "100.00"
        self.fromCurrency = .init(acronym: "PLN", flag: UIImage(resource: .plImg), id: UUID(), sendingLimit: 20000, country: "Poland", fullName: "Polish zloty")
        self.toAmount = "0.0"
        self.toCurrency = .init(acronym: "UAH", flag: UIImage(resource: .uaImg), id: UUID(), sendingLimit: 50000, country: "Ukraine", fullName: "Hrivna")
        self.rate = 0.0
    }
    
    func swapCurrencies() {
        (fromCurrency, fromAmount, toCurrency, toAmount) = (toCurrency, toAmount, fromCurrency, String(0.0))
        rate = 0.0
        updateRate()
    }
    
    func updateRate() {
        ApiClient.shared.getRateCurrencies(from: fromCurrency, to: toCurrency, amount: fromAmount)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            } receiveValue: { response in
                DispatchQueue.main.async {
                    self.rate = response.rate
                    self.toAmount = String(response.toAmount)
                }
            }
            .store(in: &cancellables)
    }
}
