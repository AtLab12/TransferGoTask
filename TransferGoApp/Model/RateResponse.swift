//
//  RateResponse.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 02/03/2024.
//

import Foundation

struct RateResponse: Codable {
    let from, to: String
    let rate, fromAmount, toAmount: Double
}
