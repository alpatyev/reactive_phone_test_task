import UIKit

// MARK: - Setup attributed placeholder for UITextfield

extension UITextField {
    func setPlaceholder(text: String, color: UIColor) {
        let attributes = [NSAttributedString.Key.foregroundColor: color,
                          NSAttributedString.Key.font: Constants.Fonts.subTitle]
        attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
    }
}
