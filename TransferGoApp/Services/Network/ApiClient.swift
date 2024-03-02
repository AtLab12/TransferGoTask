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
            .init(acronym: "PLN", flag: UIImage(resource: .plImg), id: UUID(), sendingLimit: 20000, country: "Poland", fullName: "Polish zloty"),
            .init(acronym: "EUR", flag: UIImage(resource: .deImg), id: UUID(), sendingLimit: 5000, country: "Germany", fullName: "Euro"),
            .init(acronym: "GBP", flag: UIImage(resource: .gbImg), id: UUID(), sendingLimit: 1000, country: "Great Britain", fullName: "British Pound"),
            .init(acronym: "UAH", flag: UIImage(resource: .uaImg), id: UUID(), sendingLimit: 50000, country: "Ukraine", fullName: "Hrivna")
        ]
    }
}
