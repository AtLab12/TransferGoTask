//
//  CurrencyChangeViewModel.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 01/03/2024.
//

import Foundation

@Observable
final class CurrencyChangeViewModel: Identifiable {
    let directionIdentifier: CellDirectionIdentifier
    let id: UUID
    var availableCurrencies: [Currency] = []
    var searchResult: [Currency] = []
    let searchBase: SearchBase
    
    init(directionIdentifier: CellDirectionIdentifier) {
        self.directionIdentifier = directionIdentifier
        self.id = UUID()
        self.searchBase = SearchBase()
    }
    
    func fetchCurrencies() {
        availableCurrencies = ApiClient().getAvailableCurrencies()
        searchBase.updateSearchBase(currencies: availableCurrencies)
    }
    
    func performSearch(phrase: String) {
        if phrase.isEmpty {
            searchResult = []
        } else {
            let foundIds = searchBase.search(phrase: phrase)
            searchResult = availableCurrencies.filter { foundIds.contains($0.id) }
        }
    }
}

#if DEBUG

extension CurrencyChangeViewModel {
    static let mock: CurrencyChangeViewModel = .init(directionIdentifier: .from)
}

#endif
