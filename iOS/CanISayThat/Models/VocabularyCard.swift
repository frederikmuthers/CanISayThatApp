//
//  VocabularyData.swift
//  CanISayThat
//
//  Created by Frederik Muthers on 20.05.25.
//
import Foundation
import GRDB


struct VocabularyCard: Codable, Identifiable, PersistableRecord, FetchableRecord {
    var id: Int64?
    var word: String
    var translation: String
    var lastStudied: Date?
    var masteryLevel: Int = 0
    
    
}

extension VocabularyCard {
    enum Columns {
        static let id = Column(CodingKeys.id)
        static let word = Column(CodingKeys.word)
        static let translation = Column(CodingKeys.translation)
        static let lastStudied = Column(CodingKeys.lastStudied)
        static let masteryLevel = Column(CodingKeys.masteryLevel)
    }
    
    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
    
}


class VocabularyCardManager: ObservableObject {
    @Published var items: [VocabularyCard] = [] {
        didSet {
            save()
        }
    }
    
    private let filename = "vocabulary.json"
    
    init() {
        load()
    }
    
    private var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
    }
    
    
    
    func load() {
        do {
            let data = try Data(contentsOf: fileURL)
            items = try JSONDecoder().decode([VocabularyCard].self, from: data)
        } catch {
            items = []
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: fileURL, options: [.atomicWrite])
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    func add(_ item: VocabularyCard) {
        items.append(item)
    }
    
    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    
    func update(_ item: VocabularyCard) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index] = item
    }
    
}
