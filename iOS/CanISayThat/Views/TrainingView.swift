//
//  TrainingView.swift
//  CanISayThat
//
//  Created by Frederik Muthers on 04.06.25.
//

import SwiftUI

struct TrainingView: View {
    
    let trainingCards: [VocabularyCard]
    
    @State private var currentCardIndex: Int = 0
    
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        
        VStack {
            Spacer()
            Text(trainingCards[currentCardIndex].word)
                .font(.largeTitle)
                .frame(maxWidth: .infinity, maxHeight: 300)
                .background(RoundedRectangle(cornerRadius: 10).fill(.gray))
                .padding()
                .onTapGesture {
                    
                }
            
            Spacer()
            
            HStack {
                Button("Previous") {
                    if currentCardIndex > 0 {
                        currentCardIndex -= 1
                    }
                }
                .disabled(currentCardIndex == 0)
                // Spacer()
                Button("Next") {
                    if currentCardIndex < trainingCards.count - 1 {
                        currentCardIndex += 1
                    } else {
                        dismiss()
                    }
                }
                .disabled(currentCardIndex == trainingCards.count - 1)
            }
        }
    }
}

#Preview {
    TrainingView(trainingCards: [VocabularyCard(word: "Hello", translation: "Hallo"), VocabularyCard(word: "Goodbye", translation: "Tschüss"), VocabularyCard(word: "Thank you", translation: "Danke")])
}
