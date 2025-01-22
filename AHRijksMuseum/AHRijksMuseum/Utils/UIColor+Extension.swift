import UIKit

extension UIColor {

    public convenience init?(_ hexString: String?) {
        guard let hexString, hexString.hasPrefix("#") else {
            return nil
        }
        let red, green, blue, alpha: CGFloat
        let start = hexString.index(hexString.startIndex, offsetBy: 1)
        let hexColor = String(hexString[start...])
        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            if scanner.scanHexInt64(&hexNumber) {
                red = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                blue = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                alpha = CGFloat(hexNumber & 0x000000ff) / 255
                self.init(red: red, green: green, blue: blue, alpha: alpha)
                return
            }
        } else if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            if scanner.scanHexInt64(&hexNumber) {
                red = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                blue = CGFloat((hexNumber & 0x0000ff)) / 255
                self.init(red: red, green: green, blue: blue, alpha: 1.0)
                return
            }
        }
        return nil
    }
}
