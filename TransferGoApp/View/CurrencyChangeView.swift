//
//  CurrencyChangeView.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 01/03/2024.
//

import Foundation
import SwiftUI

struct CurrencyConverterView: View {
    
    let viewModel: CurrencyChangeViewModel
    
    init(viewModel: CurrencyChangeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("Change")
    }
}

#Preview {
    CurrencyConverterView(viewModel: .init(directionIdentifier: .from, currency: .init(acronym: "PLN", flag: UIImage(resource: .plImg), id: UUID(), sendingLimit: 20000)))
}
