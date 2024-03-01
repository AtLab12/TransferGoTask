//
//  ApiClient.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 01/03/2024.
//

import Foundation
import UIKit

final class ApiClient {
    
    static let shared: ApiClient = ApiClient()
    
    private init() {}
    
    // simulated network call
    func getAvailableCurrencies() -> [Currency] {
        return [
            .init(acronym: "PLN", flag: UIImage(resource: .plImg), id: UUID(), sendingLimit: 20000),
            .init(acronym: "EUR", flag: UIImage(resource: .deImg), id: UUID(), sendingLimit: 5000),
            .init(acronym: "GBP", flag: UIImage(resource: .gbImg), id: UUID(), sendingLimit: 1000),
            .init(acronym: "UAH", flag: UIImage(resource: .uaImg), id: UUID(), sendingLimit: 50000)
        ]
    }
}
