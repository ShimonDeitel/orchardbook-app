import XCTest
@testable import OrchardBook

@MainActor
final class OrchardBookTests: XCTestCase {
    var store: Store!

    override func setUp() async throws {
        store = Store()
    }

    func testSeedDataLoadsBelowFreeLimit() {
        XCTAssertLessThan(store.entries.count, Store.freeTierLimit)
    }

    func testAddEntryIncreasesCount() {
        let before = store.entries.count
        store.add(TreeEntry(treeName: "Test Entry"))
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testAddedEntryAppearsFirst() {
        store.add(TreeEntry(treeName: "Newest"))
        XCTAssertEqual(store.entries.first?.treeName, "Newest")
    }

    func testDeleteRemovesEntry() {
        let entry = TreeEntry(treeName: "ToDelete")
        store.add(entry)
        store.delete(entry)
        XCTAssertFalse(store.entries.contains(entry))
    }

    func testCanAddMoreWhenBelowLimit() {
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtFreeLimitWithoutPro() {
        store.entries = (0..<Store.freeTierLimit).map { _ in TreeEntry(treeName: "X") }
        XCTAssertFalse(store.canAddMore)
    }

    func testAddBlockedAtLimitDoesNotAppend() {
        store.entries = (0..<Store.freeTierLimit).map { _ in TreeEntry(treeName: "X") }
        let before = store.entries.count
        store.add(TreeEntry(treeName: "Overflow"))
        XCTAssertEqual(store.entries.count, before)
    }

    func testUpdateModifiesExistingEntry() {
        let entry = TreeEntry(treeName: "Original")
        store.add(entry)
        var updated = entry
        updated.treeName = "Updated"
        store.update(updated)
        XCTAssertEqual(store.entries.first(where: { $0.id == entry.id })?.treeName, "Updated")
    }
}
