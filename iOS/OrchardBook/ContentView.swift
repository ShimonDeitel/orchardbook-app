import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchaseManager: PurchaseManager

    @State private var showingAdd = false
    @State private var showingSettings = false
    @State private var showingPaywall = false
    @State private var editingEntry: TreeEntry?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                if store.entries.isEmpty {
                    ContentUnavailableView("No Tree Log Entries Yet", systemImage: "square.and.pencil", description: Text("Tap + to add your first entry."))
                        .foregroundStyle(Theme.textPrimary)
                } else {
                    List {
                        ForEach(store.entries) { entry in
                            Button {
                                editingEntry = entry
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(entry.treeName.isEmpty ? "Untitled" : entry.treeName)
                                        .font(Theme.bodyFont.bold())
                                        .foregroundStyle(Theme.textPrimary)
                                    Text(entry.createdAt.formatted(date: .abbreviated, time: .omitted))
                                        .font(.caption)
                                        .foregroundStyle(Theme.textPrimary.opacity(0.6))
                                }
                            }
                            .accessibilityIdentifier("entryRow_\(entry.id.uuidString)")
                            .listRowBackground(Theme.background)
                        }
                        .onDelete { offsets in
                            store.delete(at: offsets)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Orchard Book")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addEntryButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                EntryEditorView(entry: nil)
            }
            .sheet(item: $editingEntry) { entry in
                EntryEditorView(entry: entry)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .tint(Theme.accent)
        }
    }
}

struct EntryEditorView: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss
    let entry: TreeEntry?

    @State private var draft: TreeEntry
    @State private var draftDate: Date = Date()

    init(entry: TreeEntry?) {
        self.entry = entry
        _draft = State(initialValue: entry ?? TreeEntry())
        _draftDate = State(initialValue: entry?.createdAt ?? Date())
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                Form {
                TextField("Tree Name", text: $draft.treeName)
                    .accessibilityIdentifier("field_treeName")
                TextField("Care Type", text: $draft.careType)
                    .accessibilityIdentifier("field_careType")
                TextField("Notes", text: $draft.notes)
                    .accessibilityIdentifier("field_notes")
                    DatePicker("Date", selection: $draftDate, displayedComponents: .date)
                        .accessibilityIdentifier("field_date")
                }
                .scrollContentBackground(.hidden)
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .navigationTitle(entry == nil ? "New Entry" : "Edit Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelEntryButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        var toSave = draft
                        toSave.createdAt = draftDate
                        if entry == nil {
                            store.add(toSave)
                        } else {
                            store.update(toSave)
                        }
                        dismiss()
                    }
                    .accessibilityIdentifier("saveEntryButton")
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
