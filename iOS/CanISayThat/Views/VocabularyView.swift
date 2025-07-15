//
//  VocabularyView.swift
//  CanISayThat
//
//  Created by Frederik Muthers on 20.05.25.
//

import SwiftUI

struct VocabularyView: View {
    
    @StateObject private var vocabularyManager = VocabularyCardManager()
    @State private var sortOption: SortOption = .wordAscending
    
    
    enum SortOption: String, CaseIterable, Identifiable {
        case wordAscending = "Word (A-Z)"
        case wordDescending = "Word (Z-A)"
        case lastStudiedAscending = "Last Studied (Oldest First)"
        case lastStudiedDescending = "Last Studied (Newest First)"
        
        var id: String { self.rawValue }

    }

    
    var body: some View {
        VStack(spacing: 0) {
            NavigationView {
                List {
                    ForEach(vocabularyManager.items) { card in
                        HStack {
                            Text(card.word)
                                .font(.headline)
                            Spacer()
                            if let lastsStudied = card.lastStudied {
                                Text("Last studied: \(lastsStudied)")
                            } else {
                                Text("Never studied")
                            }
                        }
                    }
                    .onDelete(perform: deleteCard)
                }
                .navigationTitle("Vocabulary")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: addCard) {
                            Label("Add Card", systemImage: "plus")
                        }
                    }
                }
            }
            Button(action: {
                
            }) {
                Text("Start Learning")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                    .background(Color(.systemGroupedBackground))
            }
        }
    }
    
    private func addCard() {
        let newCard = VocabularyCard(word: "New Word", translation: "New Translation", masteryLevel: 0)
        vocabularyManager.add(newCard)
    }
    
    private func deleteCard(at offsets: IndexSet) {
        vocabularyManager.items.remove(atOffsets: offsets)
    }
}

#Preview {
    VocabularyView()
}
