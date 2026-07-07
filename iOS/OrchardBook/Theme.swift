import SwiftUI

/// Unique visual identity for Orchard Book.
enum Theme {
    static let background = Color(hex: "#1B2A1A")
    static let accent = Color(hex: "#7FB069")
    static let secondary = Color(hex: "#C9A66B")
    static let textPrimary = Color(hex: "#EDE7DA")

    static let titleFont: Font = .system(.largeTitle, design: .rounded).weight(.bold)
    static let bodyFont: Font = .system(.body, design: .rounded)

    static let cardCorner: CGFloat = 18
}

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var rgb: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
