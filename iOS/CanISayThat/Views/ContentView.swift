//
//  ContentView.swift
//  CanISayThat
//
//  Created by Frederik Muthers on 18.04.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView {
            SentenceFeedbackView()
                .tabItem {
                    Image(systemName: "pencil")
                    Text("Correction")
                }
            VocabularyView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Vocabulary")
                }
        }
    }
}

#Preview {
    ContentView()
}
