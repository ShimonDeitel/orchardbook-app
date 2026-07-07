import Foundation

struct TreeEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var createdAt: Date
    var treeName: String
    var careType: String
    var notes: String

    init(id: UUID = UUID(), createdAt: Date = Date(), treeName: String = "", careType: String = "", notes: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.treeName = treeName
        self.careType = careType
        self.notes = notes
    }
}
