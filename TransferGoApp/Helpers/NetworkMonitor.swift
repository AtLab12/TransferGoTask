//
//  NetworkMonitor.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 03/03/2024.
//

import Foundation
import Network
import Combine

final class NetworkMonitor {
    private var pathMonitor: NWPathMonitor
    private var pathUpdateHandler: ((NWPath) -> Void)?
    private let networkStatusSubject = PassthroughSubject<Bool, Never>()
    
    var networkStatusPublisher: AnyPublisher<Bool, Never> {
        networkStatusSubject.eraseToAnyPublisher()
    }
    
    init() {
        pathMonitor = NWPathMonitor()
        pathMonitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            self?.networkStatusSubject.send(isConnected)
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        pathMonitor.start(queue: queue)
    }
    
    deinit {
        pathMonitor.cancel()
    }
}

