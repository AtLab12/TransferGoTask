//
//  Currency.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 01/03/2024.
//

import Foundation
import UIKit

struct Currency: Identifiable, Equatable {
    let acronym: String
    let flag: UIImage
    let id: UUID
    let sendingLimit: Int
    let country: String
    let fullName: String
}

#if DEBUG

extension Currency {
    static let mock: Self = .init(
        acronym: "UAH",
        flag: UIImage(resource: .uaImg),
        id: UUID(),
        sendingLimit: 50000,
        country: "Ukraine",
        fullName: "Hrivna"
    )
}

#endif
