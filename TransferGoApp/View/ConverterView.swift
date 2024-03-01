//
//  ConverterView.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 29/02/2024.
//

import Foundation
import SwiftUI
import UIKit

struct ConverterView: View {
    
    private enum Constants {
        static let fieldWidth = UIScreen.main.bounds.width * 0.88
        static let fieldHeight = UIScreen.main.bounds.height * 0.23
        static let fieldTopPadding = 88.0
        static let cellContentHorizntalPadding = 12.0
        static let cellContentVerticalPadding = 17.0
        static let cornerRadius: CGFloat = 20
    }
    
    @Bindable var viewModel = ConverterViewModel()
    @State private var currencyChangeViewModel: CurrencyChangeViewModel? = nil
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .foregroundStyle(Color.backgroundGray)
                
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .frame(height: Constants.fieldHeight/2)
                    .foregroundStyle(Color.white)
                    .shadow(color: Color.shadow, radius: 5)
                
                VStack {
                    InputCellView(directionIdentifier: .from, selectedCurrency: $viewModel.fromCurrency, amount: $viewModel.fromAmount, currencyChangeViewModel: $currencyChangeViewModel)
                    
                    Spacer()
                    
                    InputCellView(directionIdentifier: .to, selectedCurrency: $viewModel.toCurrency, amount: $viewModel.toAmount, currencyChangeViewModel: $currencyChangeViewModel)
                }
                .padding(.horizontal, Constants.cellContentHorizntalPadding)
                .padding(.vertical, Constants.cellContentVerticalPadding)
                
                
            }
            .frame(width: Constants.fieldWidth, height: Constants.fieldHeight)
            .padding(.top, Constants.fieldTopPadding)
            
            Spacer()
        }
        .sheet(item: $currencyChangeViewModel) {
            CurrencyConverterView(viewModel: $0)
        }
    }
}

#Preview {
    ConverterView()
}
