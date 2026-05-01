//
//  ShadowSP.swift
//  SipWise
//
//  Created by MAC on 2026/5/1.
//

import SwiftUI

struct ShadowSP: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(UIColor.secondarySystemGroupedBackground))
                    .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: 4)
            )
    }
}

extension View {
    func shadowSP() -> some View {
        self.modifier(ShadowSP())
    }
}
