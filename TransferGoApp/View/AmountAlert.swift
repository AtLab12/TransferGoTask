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
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .frame(height: 32)
            .foregroundStyle(Color.red.opacity(0.2))
            .overlay {
                HStack(spacing: 5) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 15, weight: .semibold))
                    
                    Text(alert.title)
                        .font(.system(size: 13))
                }
                .foregroundStyle(Color.red)
                .padding(.horizontal)
            }
    }
}

#Preview {
    AmountAlert(alert: .init(title: "Maximum sending amount: \(10000) " + ("PLN"), subtitle: ""))
}
