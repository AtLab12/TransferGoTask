//
//  URLSessionNetworkingService\.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 03/03/2024.
//

import Foundation
import Combine

class URLSessionNetworkingService: NetworkingService {
    func fetchData(from url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}

