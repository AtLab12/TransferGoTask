//
//  NetworkingService.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 03/03/2024.
//

import Foundation
import Combine

protocol NetworkingService {
    func fetchData(from url: URL) -> AnyPublisher<Data, Error>
}
