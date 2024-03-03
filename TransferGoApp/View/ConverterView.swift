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
        static let swapButtonSize = 24.0
        static let swapButtonFontSize = 12.0
        static let rateVerticalPadding = 4.0
        static let rateHorizontalPadding = 6.0
        static let rateTextSize = 12.0
    }
    
    @StateObject private var viewModel = ConverterViewModel()
    @State private var currencyChangeViewModel: CurrencyChangeViewModel? = nil
    
    var body: some View {
        VStack {
            ZStack{
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .foregroundStyle(Color.backgroundGray)
                
                VStack {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .frame(height: Constants.fieldHeight/2)
                        .foregroundStyle(Color.white)
                        .shadow(color: Color.shadow, radius: 5)
                    
                    Spacer()
                }
                
                VStack {
                    InputCellView(directionIdentifier: .from, selectedCurrency: $viewModel.fromCurrency, amount: $viewModel.fromAmount, currencyChangeViewModel: $currencyChangeViewModel)
                    
                    Spacer()
                    
                    InputCellView(directionIdentifier: .to, selectedCurrency: $viewModel.toCurrency, amount: $viewModel.toAmount, currencyChangeViewModel: $currencyChangeViewModel)
                }
                .padding(.horizontal, Constants.cellContentHorizntalPadding)
                .padding(.vertical, Constants.cellContentVerticalPadding)
                
                Button {
                    withAnimation {
                        viewModel.swapCurrencies()
                    }
                } label: {
                    Circle()
                        .foregroundStyle(Color.blue)
                        .frame(width: Constants.swapButtonSize)
                        .overlay {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: Constants.swapButtonFontSize, weight: .bold))
                                .foregroundStyle(Color.white)
                        }
                }
                .offset(x: -Constants.fieldWidth * 0.33)
                
                Text(viewModel.rateLabel)
                    .font(.system(size: Constants.rateTextSize, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .padding(.vertical, Constants.rateVerticalPadding)
                    .padding(.horizontal, Constants.rateHorizontalPadding)
                    .background {
                        Capsule()
                            .foregroundStyle(Color.black)
                    }
            }
            .frame(width: Constants.fieldWidth, height: Constants.fieldHeight)
            .padding(.top, Constants.fieldTopPadding)
            
            Spacer()
        }
        .sheet(item: $currencyChangeViewModel) {
            CurrencyConverterView(
                viewModel: $0,
                selectedCurrency: $0.directionIdentifier == .from ? $viewModel.fromCurrency : $viewModel.toCurrency,
                title: $0.directionIdentifier == .from ? "Sending from" : "Receiver gets"
            )
        }
        .task {
            viewModel.updateRate()
        }
        .onChange(of: [viewModel.fromCurrency, viewModel.toCurrency]) {
            viewModel.updateRate()
        }
    }
}

#Preview {
    ConverterView()
}
