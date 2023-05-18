import UIKit

// MARK: - Sets standard appearance for message/status labels

extension UILabel {
    func setStandardAppearance() {
        textAlignment = .center
        lineBreakMode = .byWordWrapping
        numberOfLines = 4
        font = Constants.Fonts.thin
        textColor = Constants.Colors.accent
    }
}
