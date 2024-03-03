//
//  TopError.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 03/03/2024.
//

import Foundation
import SwiftUI

struct TopError: View {
    
    @Binding var error: ConverterError?
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "x.circle.fill")
                .font(.system(size: 30))
                .foregroundStyle(Color.alertRed)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(error?.title ?? "")
                    .font(.system(size: 16, weight: .bold))
                
                Text(error?.subtitle ?? "")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textGray)
            }
            
            Button {
                withAnimation {
                    error = nil
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color.textGray)
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.white)
                .shadow(color: Color.shadow, radius: 5)
        }
    }
}

#Preview {
    TopError(error: .constant(.mock))
}
