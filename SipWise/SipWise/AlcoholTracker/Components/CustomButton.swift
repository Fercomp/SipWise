//
//  CustomButton.swift
//  SipWise
//
//  Created by Fernando Santos de Souza on 28/04/26.
//

import SwiftUI

struct CustomButton: View {
    let isDisabled: Bool
    let color: Color?
    let icon: String?
    let text: String
    let action: (() -> ())?
    
    init(isDisabled: Bool = false,
         color: Color?,
         icon: String?,
         text: String,
         action: (() -> ())? = nil) {
        self.isDisabled = isDisabled
        self.color = color
        self.icon = icon
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            if let action { action() }
        }, label: {
            HStack {
                if let icon { Image(systemName: icon) }
                Text(text)
            }
            .foregroundColor(.white)
        })
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(isDisabled ? .gray.opacity(0.3) : color ?? .clear)
        .clipShape(.buttonBorder)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 3, y: 3)
        .disabled(isDisabled)
    }
}

#Preview {
    CustomButton(color: .cyan,
                 icon: "plus",
                 text: "Drink")
        .padding()
}
