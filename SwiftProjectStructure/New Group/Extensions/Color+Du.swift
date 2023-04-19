
import UIKit

// 颜色的扩展
public extension UIColor {
    
    // 根据 16 进制获取对应的颜色
    convenience init(_ hex: UInt, alpha: CGFloat = 1) {
        let r = ((hex >> 16) & 0xFF)
        let g = (hex >> 8) & 0xFF
        let b = hex & 0xFF
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    
    // 根据 16 进制字符串获取对应的颜色
    convenience init(_ hexString: String, alpha: CGFloat = 1) {
        var string = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if string.count < 6 {
            self.init(white: 0, alpha: 0)
            return
        }
        
        if string.count > 6 {
            string = String(string[string.index(string.endIndex, offsetBy: -6)...])
        }
        
        if string.count != 6 {
            self.init(white: 0, alpha: 0)
            return
        }
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner(string: (string as NSString).substring(with: NSRange(location: 0, length: 2))).scanHexInt32(&r)
        Scanner(string: (string as NSString).substring(with: NSRange(location: 2, length: 2))).scanHexInt32(&g)
        Scanner(string: (string as NSString).substring(with: NSRange(location: 4, length: 2))).scanHexInt32(&b)
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
}
