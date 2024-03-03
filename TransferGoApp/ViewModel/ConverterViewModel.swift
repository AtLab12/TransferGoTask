//
//  ConverterViewModel.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 01/03/2024.
//

import Foundation
import UIKit
import Combine
import SwiftUI

final class ConverterViewModel: ObservableObject {
    
    @Published var fromAmount: String = "100.00"
    @Published var fromCurrency: Currency
    
    @Published var toAmount: String = "0.0"
    @Published var toCurrency: Currency
    
    @Published public private(set) var rate: Double = 0.0
    
    @Published var error: ConverterError? = nil
    @Published public private(set) var amountError: ConverterError? = nil
    
    private var lastCheck = ("0.0", "0.0")
    private let networkMonitor = NetworkMonitor()
    private let apiClient: ApiClient
    
    public var rateLabel: String {
        "1 \(fromCurrency.acronym) = \(rate) \(toCurrency.acronym)"
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(apiClient: ApiClient = .init()) {
        self.apiClient = apiClient
        self.fromCurrency = .init(acronym: "PLN", flag: UIImage(resource: .plImg), id: UUID(), sendingLimit: 20000, country: "Poland", fullName: "Polish zloty")
        self.toCurrency = .init(acronym: "UAH", flag: UIImage(resource: .uaImg), id: UUID(), sendingLimit: 50000, country: "Ukraine", fullName: "Hrivna")
        
        $fromAmount
            .flatMap { [weak self] (amountString) -> AnyPublisher<String, Never> in
                guard let amount = Double(amountString), let limit = self?.fromCurrency.sendingLimit else {
                    return Empty<String, Never>(completeImmediately: false).eraseToAnyPublisher()
                }
                
                if amount > Double(limit) {
                    DispatchQueue.main.async {
                        withAnimation {
                            self?.amountError = .init(title: "Maximum sending amount: \(limit) " + (self?.fromCurrency.acronym ?? ""), subtitle: "")
                        }
                    }
                    return Empty<String, Never>(completeImmediately: false).eraseToAnyPublisher()
                } else {
                    DispatchQueue.main.async {
                        withAnimation {
                            self?.amountError = nil
                        }
                    }
                    return Just(amountString).eraseToAnyPublisher()
                }
            }
            .debounce(for: .seconds(0.75), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.updateRate(initiatedBy: .from)
            }
            .store(in: &cancellables)
        
        $toAmount
            .debounce(for: .seconds(0.75), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.updateRate(initiatedBy: .to)
            }
            .store(in: &cancellables)
        
        networkMonitor
            .networkStatusPublisher
            .sink { isConnected in
                if !isConnected {
                    DispatchQueue.main.async {
                        self.error = .init(title: "No network", subtitle: "Check your internet connection")
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func swapCurrencies() {
        (fromCurrency, fromAmount, toCurrency, toAmount) = (toCurrency, toAmount, fromCurrency, String(0.0))
        rate = 0.0
        updateRate()
        amountError = nil
    }
    
    func updateRate(initiatedBy: CellDirectionIdentifier = .from) {
        if (fromAmount, toAmount) != lastCheck && (amountError == nil || initiatedBy == .to) {
            apiClient.getRateCurrencies(
                from: initiatedBy == .from ? fromCurrency : toCurrency,
                to: initiatedBy == .from ? toCurrency : fromCurrency,
                amount: initiatedBy == .from ? fromAmount : toAmount
            )
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    self.error = .init(title: "Convertion error", subtitle: "App failed to convert amount")
                }
            } receiveValue: { response in
                DispatchQueue.main.async {
                    if response.from == self.fromCurrency.acronym {
                        self.toAmount = String(response.toAmount)
                        self.fromAmount = String(response.fromAmount)
                        self.rate = response.rate
                        self.lastCheck = (String(response.fromAmount), String(response.toAmount))
                    } else {
                        self.toAmount = String(response.fromAmount)
                        self.fromAmount = String(response.toAmount)
                        self.lastCheck = (String(response.toAmount), String(response.fromAmount))
                    }
                }
            }
            .store(in: &cancellables)
        }
    }
}
