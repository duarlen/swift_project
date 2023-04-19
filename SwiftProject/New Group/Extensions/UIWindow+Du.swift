
import UIKit

public extension UIWindow {
    
    /// APP 的主 Window
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            for windowScene in UIApplication.shared.connectedScenes {
                if let scene = windowScene as? UIWindowScene, scene.activationState == .foregroundActive {
                    for window in scene.windows where window.isKeyWindow {
                        return window
                    }
                }
            }
        } else {
            return UIApplication.shared.keyWindow
        }
       return nil
    }
}
