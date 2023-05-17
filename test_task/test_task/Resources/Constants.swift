import UIKit

// MARK: - Common application UI constants

enum Constants {
    
    // MARK: - Colors environement
    
    enum Colors {
        static let background = UIColor.white
        static let backgroundAccent = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.00)
        
        static let primaryText = UIColor.black
        static let secondaryText = UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 1.00)
        
        static let accent = UIColor(red: 0.08, green: 1.00, blue: 0.86, alpha: 1.00)
    }
    
    // MARK: - Fonts environement

    enum Fonts {
        static let title: UIFont = .systemFont(ofSize: 25, weight: .medium)
        static let body: UIFont = .systemFont(ofSize: 16, weight: .regular)
        static let thin: UIFont = .italicSystemFont(ofSize: 18)
    }
    
    // MARK: - Layout environement
    
    enum Layout {
        static let smallPadding: CGFloat = 14
        static let smallElementHeight: CGFloat = 36
        static let smallCornerRadius: CGFloat = 12
        
        static let mediumPadding: CGFloat = 40
        static let mediumCornerRadius: CGFloat = 16
        
        static let defaultBorderWidth: CGFloat = 2
        static let emdededContentMultiplier: CGFloat = 0.84
    }
    
    // MARK: - Text environement
    
    enum Text {
        enum Search_Tab {
            static let placeholder = NSLocalizedString("Search_Tab.placeholder", comment: "")
            static let navigationTitle = NSLocalizedString("Search_Tab.navigationTitle", comment: "")
        }
        
        enum Favorites_Tab {
            static let navigationTitle = NSLocalizedString("Favorites_Tab.navigationTitle", comment: "")
        }
    }
 }
