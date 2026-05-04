//
//  HistoryView.swift
//  SipWise
//
//  Created by Fernando Santos de Souza on 23/04/26.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \HistoryModel.day, order: .reverse)
    private var histories: [HistoryModel]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(histories.indices, id: \.self) { index in
                    HistoryCardView(model: histories[index])
                }
            }
            .padding()
        }
    }
}

#Preview {
    HistoryView()
}
