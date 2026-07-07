import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @AppStorage("notifyReminders") private var notifyReminders: Bool = true
    @AppStorage("showTips") private var showTips: Bool = true

    var body: some View {
        NavigationStack {
            List {
                Section("Preferences") {
                    Toggle("Reminders", isOn: $notifyReminders)
                        .accessibilityIdentifier("remindersToggle")
                    Toggle("Show Tips", isOn: $showTips)
                        .accessibilityIdentifier("tipsToggle")
                }
                Section("Pro") {
                    if purchaseManager.isPro {
                        Label("Pro Unlocked", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(Theme.accent)
                    } else {
                        Button("Upgrade to Pro") {}
                            .accessibilityIdentifier("openPaywallFromSettingsButton")
                    }
                    Button("Restore Purchases") {
                        Task { await purchaseManager.restore() }
                    }
                    .accessibilityIdentifier("settingsRestoreButton")
                }
                Section("About") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/orchardbook-app/privacy.html")!)
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/orchardbook-app/terms.html")!)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("settingsDoneButton")
                }
            }
        }
    }
}
