import UIKit

// MARK: - UIButton for main actions

extension UIButton {
    func highlightable(accentColor: UIColor, title: String) {
        layer.masksToBounds = true
        layer.borderWidth = Constants.Layout.defaultBorderWidth
        layer.cornerRadius = Constants.Layout.smallCornerRadius
        layer.borderColor = accentColor.cgColor
        setTitle(title, for: .normal)
        setTitleColor(accentColor, for: .normal)
        setTitleColor(Constants.Colors.background, for: .highlighted)
        setBackgroundImage(UIImage.solidColor(color: accentColor), for: .highlighted)
        setBackgroundImage(UIImage.solidColor(color: Constants.Colors.background), for: .normal)
    }
}
