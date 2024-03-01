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
    let currency: Currency
    let id: UUID
    
    init(directionIdentifier: CellDirectionIdentifier, currency: Currency) {
        self.directionIdentifier = directionIdentifier
        self.currency = currency
        self.id = currency.id
    }
}

#if DEBUG

extension CurrencyChangeViewModel {
    static let mock: CurrencyChangeViewModel = .init(
        directionIdentifier: .from,
        currency: .mock
    )
}

#endif
