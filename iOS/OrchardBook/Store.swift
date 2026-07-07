import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [TreeEntry] = []
    @Published var isProUnlocked: Bool = false

    /// Free tier keeps every seeded entry visible without hitting the paywall on first launch.
    static let freeTierLimit = 20

    private let fileURL: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let dir = appSupport.appendingPathComponent("OrchardBook", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("entries.json")
        load()
    }

    var canAddMore: Bool {
        isProUnlocked || entries.count < Store.freeTierLimit
    }

    func add(_ entry: TreeEntry) {
        guard canAddMore else { return }
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: TreeEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: TreeEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([TreeEntry].self, from: data) {
            entries = decoded
        } else {
            entries = Store.seedData()
            save()
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    static func seedData() -> [TreeEntry] {
        [
        TreeEntry(treeName: "Tree Log 1", careType: "Tree Log 1", notes: "Tree Log 1"),
        TreeEntry(treeName: "Tree Log 2", careType: "Tree Log 2", notes: "Tree Log 2"),
        TreeEntry(treeName: "Tree Log 3", careType: "Tree Log 3", notes: "Tree Log 3"),
        TreeEntry(treeName: "Tree Log 4", careType: "Tree Log 4", notes: "Tree Log 4")
        ]
    }
}
