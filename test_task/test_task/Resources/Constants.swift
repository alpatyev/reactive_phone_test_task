import UIKit

// MARK: - Common application UI constants

enum Constants {
    
    // MARK: - Colors environement
    
    enum Colors {
        static let background = UIColor.white
        static let backgroundAccent = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.00)
        static let primaryText = UIColor.black
        static let secondaryText = UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.00)
        static let accent = UIColor(red: 0.04, green: 0.78, blue: 1.00, alpha: 1.00)
        static let destructive = UIColor(red: 1.00, green: 0.09, blue: 0.18, alpha: 1.00)
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
        static let smallCornerRadius: CGFloat = 10
        static let mediumPadding: CGFloat = 40
        static let mediumCornerRadius: CGFloat = 24
        static let defaultBorderWidth: CGFloat = 2
        static let emdededContentMultiplier: CGFloat = 0.84
        static let defaultRowHeight: CGFloat = 80
    }
    
    // MARK: - Asset images names environement
    
    enum ImageNames {
        static let info: String = "info.circle"
        static let search: String = "sparkle.magnifyingglass"
        static let favorites: String = "star.fill"
        static let list: String = "rectangle.grid.1x2.fill"
    }
    
    // MARK: - Text environement
    
    enum Text {
        enum Search_Tab {
            static let placeholder = NSLocalizedString("Search_Tab.placeholder", comment: "")
            static let navigationTitle = NSLocalizedString("Search_Tab.navigationTitle", comment: "")
            static let imageDefaultLabel = NSLocalizedString("Search_Tab.imageDefaultLabel", comment: "")
            static let saveButton = NSLocalizedString("Search_Tab.saveButton", comment: "")
            static let removeButton = NSLocalizedString("Search_Tab.removeButton", comment: "")
            static let clearDataButton = NSLocalizedString("Search_Tab.clearDataButton", comment: "")
            static let noImageFounded = NSLocalizedString("Search_Tab.noImageFounded", comment: "")
        }
        
        enum Favorites_Tab {
            static let navigationTitle = NSLocalizedString("Favorites_Tab.navigationTitle", comment: "")
            static let emptyListText = NSLocalizedString("Favorites_Tab.emptyListText", comment: "")
            static var showInfo: (_ saved: Int, _ limit: Int) -> String = { saved, limit in
                String(format: NSLocalizedString("Favorites_Tab.showInfo", comment: ""), saved, limit)
            }
        }
    }
    
    // MARK: - Logic environement
    
    enum Logic {
        static let imageItemsLimit: Int = 20
    }
 }
