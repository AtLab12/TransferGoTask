//
//  SearchView.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 02/03/2024.
//

import Foundation
import SwiftUI

struct SearchView: View {
    
    @Binding var searchText: String
    @FocusState private var isTextFieldFocused: Bool
    
    private enum Constants {
        static let textHoriznotalPadding = 8.0
        static let textFontSize = 20.0
        static let verticalPadding = 5.0
        static let borderCornerRadius = 10.0
        static let borderLineWidth = 2.0
    }
    
    var body: some View {
        TextField("", text: $searchText)
            .accessibilityIdentifier("SearchBar")
            .padding(.horizontal, Constants.textHoriznotalPadding)
            .font(.system(size: Constants.textFontSize))
            .focused($isTextFieldFocused)
            .background {
                if searchText.isEmpty && !isTextFieldFocused {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .padding(.leading, Constants.textHoriznotalPadding)
                        
                        Spacer()
                    }
                }
            }
            .padding(.vertical, Constants.verticalPadding)
            .overlay {
                GeometryReader { proxy in
                    ZStack {
                        RoundedRectangle(cornerRadius: Constants.borderCornerRadius)
                            .stroke(lineWidth: Constants.borderLineWidth)
                        
                        Text("Search")
                            .font(.system(size: 16))
                            .padding(.horizontal, 3)
                            .background { Color.white }
                            .offset(x: -proxy.frame(in: .local).width/2*0.8 ,y: -proxy.frame(in: .local).height/2)
                    }
                }
            }
            .foregroundStyle(Color.textFieldGray)
    }
}

#Preview {
    SearchView(searchText: .constant(""))
}
