import Foundation
import UIKit

public extension UIActivityIndicatorView {
    static func loaderView() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor.accent
        indicator.startAnimating()
        indicator.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }
}
