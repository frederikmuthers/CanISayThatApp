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
    @State private var correctedSentence: String = "Provide a sentence to receive feedback."
    @State private var explanationItalian: String = ""
    @State private var explanationEnglish: String = ""
    @State private var nativeLike: String = "no"
    @State private var tone: String = "positive"
    
    @State private var hasLoaded: Bool = true
    @State private var isLoading: Bool = false
    
    
        var body: some View {
            
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Correction")
                    .font(.title2)
                    .bold()

                VStack(spacing: 16) {
                    // TextField
                    TextField("Give me a sentence...", text: $sentence)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(nativeLike == "yes" ? Color.green.opacity(0.4) : Color.red.opacity(0.4)))
                        .font(.body)
                        .foregroundColor(.primary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(1), lineWidth: 2)
                        )
                    
                    // Corrected Sentence
                    
                    if !isLoading {
                        Text(correctedSentence)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                            .font(.body)
                            .foregroundColor(.primary)
                    } else {
                        ProgressView("Loading...") // Optional loading indicator
                            .padding()
                    }
                    
                }
                

                Button(action: {
                    hasLoaded = false
                    isLoading = true
                    submittedSentence = sentence
                    correctionAPI.send(sentence: sentence) { response in
                        if let response = response {
                            correctedSentence = response.corrected_sentence
                            explanationItalian = response.feedback_italian
                            explanationEnglish = response.feedback_english
                            nativeLike = response.native_like
                            tone = response.tone
                            hasLoaded = true
                            isLoading = false
                        } else {
                            correctedSentence = "Error: Please try again."
                            hasLoaded = false
                            isLoading = false
                        }
                    }
                }) {
                    Text("Send")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }


                if hasLoaded {
                    
                    
                    
                    VStack(alignment: .leading, spacing: 10) {
                        if !tone.isEmpty {
                            HStack {
                                Text("Tone:")
                                    .font(.headline)
                                Text(tone)
                            }
                            
                        }
                        Text("Spiegazione (IT):")
                            .font(.headline)
                        Text(explanationItalian)

                        Text("Explanation (EN):")
                            .font(.headline)
                        Text(explanationEnglish)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                        .font(.body)
                        .foregroundColor(.primary)
                }

                Spacer()
            }
            .padding()
        }
    }


#Preview {
    SentenceFeedbackView()
}
