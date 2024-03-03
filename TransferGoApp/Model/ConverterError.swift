//
//  ConverterError.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 03/03/2024.
//

import Foundation

struct ConverterError: Error {
    let title: String
    let subtitle: String
}

#if DEBUG

extension ConverterError {
    static let mockNoSubtitle: Self = .init(title: "Maximum sending amount: \(20000) " + "PLN", subtitle: "")
    static let mock: Self = .init(title: "No network", subtitle: "Check your internet connection")
}

#endif
