import UIKit

// MARK: - Setup default UITableViewCell

extension UITableViewCell {
    func setup(with model: ImageItemModel) {
        imageView?.clipsToBounds = true
        imageView?.layer.cornerRadius = Constants.Layout.smallCornerRadius / 2
        imageView?.contentMode = .scaleToFill
        imageView?.backgroundColor = Constants.Colors.backgroundAccent
        imageView?.image = UIImage(data: model.imageData)

        textLabel?.text = model.prompt
        textLabel?.font = Constants.Fonts.subTitle
        textLabel?.textColor = Constants.Colors.primaryText
        
        accessoryType = .disclosureIndicator
    }
}
