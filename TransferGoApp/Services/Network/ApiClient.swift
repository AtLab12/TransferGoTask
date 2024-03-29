//
//  ApiClient.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 01/03/2024.
//

import Foundation
import UIKit
import Combine

final class ApiClient {
    
    private let networkingService: NetworkingService
    
    init(networkingService: NetworkingService = URLSessionNetworkingService()) {
        self.networkingService = networkingService
    }
    
    // simulated network call
    func getAvailableCurrencies() -> [Currency] {
        return [
            .init(acronym: "PLN", flag: UIImage(resource: .plImg), id: UUID(), sendingLimit: 20000, country: "Poland", fullName: "Polish zloty"),
            .init(acronym: "EUR", flag: UIImage(resource: .deImg), id: UUID(), sendingLimit: 5000, country: "Germany", fullName: "Euro"),
            .init(acronym: "GBP", flag: UIImage(resource: .gbImg), id: UUID(), sendingLimit: 1000, country: "Great Britain", fullName: "British Pound"),
            .init(acronym: "UAH", flag: UIImage(resource: .uaImg), id: UUID(), sendingLimit: 50000, country: "Ukraine", fullName: "Hrivna")
        ]
    }
    
    func getRateCurrencies(from cur1: Currency, to cur2: Currency, amount: String) -> AnyPublisher<RateResponse, Error> {
        guard var urlComponent = URLComponents(string: "https://my.transfergo.com/api/fx-rates") else {
            return Fail(error: ApiClientError.failedToContrustComponent).eraseToAnyPublisher()
        }
        
        urlComponent.queryItems = [
            URLQueryItem(name: "from", value: cur1.acronym),
            URLQueryItem(name: "to", value: cur2.acronym),
            URLQueryItem(name: "amount", value: amount)
        ]
        
        guard let url = urlComponent.url else {
            return Fail(error: ApiClientError.failedToContructURL).eraseToAnyPublisher()
        }
        
        return networkingService
            .fetchData(from: url)
            .flatMap { data -> AnyPublisher<RateResponse, Error> in
                Just(data)
                    .decode(type: RateResponse.self, decoder: JSONDecoder())
                    .mapError { $0 as Error }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    enum ApiClientError: Error {
        case failedToContrustComponent
        case failedToContructURL
    }
}
