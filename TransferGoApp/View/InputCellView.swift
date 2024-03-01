//
//  InputCellView.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 01/03/2024.
//

import Foundation
import SwiftUI

struct InputCellView: View {
    
    private enum Constants {
        static let flagStackSpacing = 8.0
        static let flagIconSize = CGSize(width: 32, height: 32)
        static let stackSpacing = 30.0
    }
    
    let directionIdentifier: CellDirectionIdentifier
    private var textColor: Color {
        switch directionIdentifier {
        case .from:
            return Color.blue
        case .to:
            return Color.black
        }
    }
    
    @Binding var selectedCurrency: Currency
    @Binding var amount: String
    @Binding var currencyChangeViewModel: CurrencyChangeViewModel?
    
    var body: some View {
        HStack(spacing: Constants.stackSpacing) {
            
            VStack(alignment: .leading, spacing: Constants.flagStackSpacing) {
                Text("Sending from")
                    .foregroundStyle(Color.textGray)
                    .fontWeight(.light)
                
                Button {
                    currencyChangeViewModel = .init(directionIdentifier: directionIdentifier, currency: selectedCurrency)
                } label: {
                    HStack(spacing: Constants.flagStackSpacing) {
                        Image(uiImage: selectedCurrency.flag)
                            .resizable()
                            .frame(width: Constants.flagIconSize.width, height: Constants.flagIconSize.height)
                        
                        Text(selectedCurrency.acronym)
                            .font(.system(size: 16, weight: .semibold))
                        
                        Image(systemName: "chevron.down")
                    }
                }
                .tint(.black)
            }
            
            TextField("Amount", text: $amount)
                .font(.system(size: 30, weight: .heavy))
                .foregroundStyle(textColor)
                .lineLimit(1)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
        }
    }
}

#Preview {
    InputCellView(
        directionIdentifier: .from,
        selectedCurrency: .constant(
        .init(acronym: "PLN", flag: UIImage(resource: .plImg), id: UUID(), sendingLimit: 20000)),
        amount: .constant("100.00"),
        currencyChangeViewModel: .constant(.mock)
    )
}
