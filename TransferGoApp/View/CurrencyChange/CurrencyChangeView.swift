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
    @Binding var selectedCurrency: Currency
    @State private var searchText: String = ""
    
    let title: String
    
    private enum Constants {
        static let titleFontSize = 24.0
        static let allCountriesSectionPadding = 24.0
        static let allCountriesFontSize = 18.0
        static let sheetContentTopPadding = 20.0
        static let dismissIndicatorTopPadding = 12.0
        static let dismissIndicatorSize = CGSize(width: 32, height: 4)
    }
    
    var body: some View {
        VStack {
            
            Capsule()
                .frame(width: Constants.dismissIndicatorSize.width, height: Constants.dismissIndicatorSize.height)
                .foregroundStyle(Color.backgroundGray)
                .padding(.top, Constants.dismissIndicatorTopPadding)
            
            Text(title)
                .font(.system(size: Constants.titleFontSize, weight: .semibold))
                .padding(.top, Constants.sheetContentTopPadding)
            
            SearchView(searchText: $searchText)
            
            HStack {
                
                Text("All countries")
                    .font(.system(size: Constants.allCountriesFontSize, weight: .semibold))
                
                Spacer()
            }
            .padding(.top, Constants.allCountriesSectionPadding)
            
            ScrollView {
                VStack {
                    ForEach(viewModel.searchResult.isEmpty ? viewModel.availableCurrencies : viewModel.searchResult, id: \.id) {
                        CurrencySelector(selectedCurrency: $selectedCurrency, selectorCurrency: $0)
                    }
                }
            }
        }
        .onChange(of: searchText) { _, newValue in
            viewModel.performSearch(phrase: newValue)
        }
        .padding(.horizontal)
        .onAppear {
            viewModel.fetchCurrencies()
        }
    }
}

#Preview {
    CurrencyConverterView(viewModel: .init(directionIdentifier: .from), selectedCurrency: .constant(.mock), title: "Sending to")
}
