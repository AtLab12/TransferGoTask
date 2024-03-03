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
    
    private var fieldTitle: String {
        switch directionIdentifier {
        case .from:
            return "Sending from"
        case .to:
            return "Receiver gets"
        }
    }
    
    @Binding var selectedCurrency: Currency
    @Binding var amount: String
    @Binding var currencyChangeViewModel: CurrencyChangeViewModel?
    
    var body: some View {
        HStack(spacing: Constants.stackSpacing) {
            
            VStack(alignment: .leading, spacing: Constants.flagStackSpacing) {
                Text(fieldTitle)
                    .foregroundStyle(Color.textGray)
                    .fontWeight(.light)
                
                Button {
                    currencyChangeViewModel = .init(directionIdentifier: directionIdentifier)
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
                .accessibilityIdentifier(directionIdentifier == .from ? "SelectFromCurrency" : "SelectToCurrency")
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
        selectedCurrency: .constant(.mock),
        amount: .constant("100.00"),
        currencyChangeViewModel: .constant(.mock)
    )
}
