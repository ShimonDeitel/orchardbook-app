import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 24) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Theme.accent)
                    .padding(.top, 40)

                Text("OrchardBook Pro")
                    .font(Theme.titleFont)
                    .foregroundStyle(Theme.textPrimary)

                Text("Yield-per-tree history and pest/treatment notes")
                    .font(Theme.bodyFont)
                    .foregroundStyle(Theme.textPrimary.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                if let product = purchaseManager.product {
                    Text(product.displayPrice + " / month")
                        .font(.headline)
                        .foregroundStyle(Theme.secondary)
                }

                Button("Unlock Pro") {
                    Task { await purchaseManager.purchase() }
                }
                .accessibilityIdentifier("unlockProButton")
                .font(.headline)
                .foregroundStyle(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Theme.accent)
                .clipShape(RoundedRectangle(cornerRadius: Theme.cardCorner))
                .padding(.horizontal, 32)

                Button("Restore Purchases") {
                    Task { await purchaseManager.restore() }
                }
                .accessibilityIdentifier("restorePurchasesButton")
                .foregroundStyle(Theme.textPrimary.opacity(0.7))

                Button("Not Now") { dismiss() }
                    .accessibilityIdentifier("dismissPaywallButton")
                    .foregroundStyle(Theme.textPrimary.opacity(0.5))
                    .padding(.top, 8)

                Spacer()
            }
        }
    }
}
