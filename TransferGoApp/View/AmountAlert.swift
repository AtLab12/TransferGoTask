//
//  AmountAlert.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 03/03/2024.
//

import Foundation
import SwiftUI

struct AmountAlert: View {
    
    let alert: ConverterError
    
    private enum Constants {
        static let cornerRadius = 5.0
        static let alertHeight = 32.0
        static let contentSpacing = 5.0
        static let titleSize = 13.0
        static let iconSize = 15.0
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .frame(height: Constants.alertHeight)
            .foregroundStyle(Color.alertRed.opacity(0.2))
            .overlay {
                HStack(spacing: Constants.contentSpacing) {
                    Image(systemName: "info.circle")
                        .font(.system(size: Constants.iconSize, weight: .semibold))
                    
                    Text(alert.title)
                        .font(.system(size: Constants.titleSize))
                }
                .foregroundStyle(Color.alertRed)
                .padding(.horizontal)
            }
    }
}

#Preview {
    AmountAlert(alert: .mockNoSubtitle)
}
