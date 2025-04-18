//
//  APIService.swift
//  CanISayThat
//
//  Created by Frederik Muthers on 18.04.25.
//

import Foundation

struct CorrectionResponse: Codable {
    let original_sentence: String
    let corrected_sentence: String
    let feedback_italian: String
    let feedback_english: String
}

class correctionAPI {
    static func send(sentence: String, completion: @escaping (CorrectionResponse?) -> Void) {
        let url = URL(string: "http://127.0.0.1:8000/corrections/correction/")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["sentence": sentence]
        request.httpBody = try? JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                    print("No data received")
                    completion(nil)
                    return
                }
            
            print(data)
            let decoder = JSONDecoder()
            do {
                let correctedResponse = try decoder.decode(CorrectionResponse.self, from: data)
                completion(correctedResponse)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}
