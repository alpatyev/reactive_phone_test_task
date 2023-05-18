import UIKit

// MARK: - Common application UI constants

enum Constants {
    
    // MARK: - Colors environement
    
    enum Colors {
        static let background = UIColor.white
        static let backgroundAccent = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.00)
        static let primaryText = UIColor.black
        static let secondaryText = UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.00)
        static let accent = UIColor(red: 0.28, green: 0.8, blue: 0.86, alpha: 1.00)
    }
    
    // MARK: - Fonts environement

    enum Fonts {
        static let title: UIFont = .systemFont(ofSize: 24, weight: .medium)
        static let subTitle: UIFont = .systemFont(ofSize: 18, weight: .medium)
        static let body: UIFont = .systemFont(ofSize: 16, weight: .regular)
        static let thin: UIFont = .italicSystemFont(ofSize: 16)
    }
    
    // MARK: - Layout environement
    
    enum Layout {
        static let smallPadding: CGFloat = 14
        static let smallElementHeight: CGFloat = 42
        static let smallCornerRadius: CGFloat = 18
        static let mediumPadding: CGFloat = 40
        static let mediumCornerRadius: CGFloat = 26
        static let defaultBorderWidth: CGFloat = 2
        static let emdededContentMultiplier: CGFloat = 0.84
    }
    
    // MARK: - Text environement
    
    enum Text {
        enum Search_Tab {
            static let placeholder = NSLocalizedString("Search_Tab.placeholder", comment: "")
            static let navigationTitle = NSLocalizedString("Search_Tab.navigationTitle", comment: "")
            static let imageDefaultText = NSLocalizedString("Search.Tab.imageDefaultText", comment: "")
        }
        
        enum Favorites_Tab {
            static let navigationTitle = NSLocalizedString("Favorites_Tab.navigationTitle", comment: "")
        }
    }
 }
