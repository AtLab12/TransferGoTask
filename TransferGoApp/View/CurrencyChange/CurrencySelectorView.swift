//
//  CurrencySelectorView.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 02/03/2024.
//

import Foundation
import SwiftUI

struct CurrencySelector: View {
    
    @Binding var selectedCurrency: Currency
    let selectorCurrency: Currency
    
    @Environment(\.dismiss) var dismiss
    
    private enum Constants {
        static let flagBackgroundSize = CGSize(width: 48, height: 48)
        static let flagIconSize = CGSize(width: 32, height: 32)
        static let selectorSubtitleSpacing = 5.0
    }
    
    var body: some View {
        Button {
            selectedCurrency = selectorCurrency
            dismiss()
        } label: {
            HStack {
                ZStack {
                    Circle()
                        .frame(width: Constants.flagBackgroundSize.width, height: Constants.flagBackgroundSize.height)
                        .foregroundStyle(Color.backgroundGray)
                    
                    Image(uiImage: selectorCurrency.flag)
                        .resizable()
                        .frame(width: Constants.flagIconSize.width, height: Constants.flagIconSize.height)
                }
                
                VStack(alignment: .leading) {
                    Text(selectorCurrency.country)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.black)
                    
                    Text("\(selectorCurrency.fullName) • \(selectorCurrency.acronym)")
                        .foregroundStyle(Color.textGray)
                        .font(.system(size: 14, weight: .light))
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    CurrencySelector(selectedCurrency: .constant(.mock), selectorCurrency: .mock)
}
