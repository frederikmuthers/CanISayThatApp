//
//  SentenceFeedbackView.swift
//  CanISayThat
//
//  Created by Frederik Muthers on 18.04.25.
//

import SwiftUI

struct SentenceFeedbackView: View {
    @State private var sentence: String = ""
        @State private var submittedSentence: String = "Hello"
        
        // Mocked data for now
        @State private var correctedSentence: String = "Oggi mi sono incontrato con i miei amici. Cosa hai fatto tu?"
        @State private var explanationItalian: String = "Rimosso 'Che' in 'Che cosa', forma più colloquiale."
        @State private var explanationEnglish: String = "Removed 'Che' in 'Che cosa', more colloquial form."

        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                Text("Correzione frase")
                    .font(.title2)
                    .bold()

                TextField("Inserisci una frase…", text: $sentence)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Invia") {
                    submittedSentence = sentence
                    correctionAPI.send(sentence: sentence) { response in
                        if let response = response {
                            correctedSentence = response.corrected_sentence
                            explanationItalian = response.feedback_italian
                            explanationEnglish = response.feedback_english
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(10)

                if !submittedSentence.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("🔹 Originale:")
                            .font(.headline)
                        Text(submittedSentence)

                        Text("🔸 Corretta:")
                            .font(.headline)
                        Text(correctedSentence)
                            .foregroundColor(.green)

                        Divider().padding(.vertical, 8)

                        Text("📘 Spiegazione (IT):")
                            .font(.headline)
                        Text(explanationItalian)

                        Text("📙 Explanation (EN):")
                            .font(.headline)
                        Text(explanationEnglish)
                    }
                    .padding(.top)
                }

                Spacer()
            }
            .padding()
        }
    }


#Preview {
    SentenceFeedbackView()
}
