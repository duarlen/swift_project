
import UIKit

public extension UIViewController {
    
    /// 获取当前的控制器
    static func currentViewController(_ viewController: UIViewController? = UIWindow.keyWindow?.rootViewController) -> UIViewController? {
        if let viewController = viewController?.presentedViewController {
            return currentViewController(viewController)
        } else if let navigationViewController = viewController as? UINavigationController {
            return currentViewController(navigationViewController.visibleViewController)
        } else if let tabBarController = viewController as? UITabBarController {
            return currentViewController(tabBarController.selectedViewController)
        } else {
            return viewController
        }
    }
    
    // 获取当前的 TabBarController
    static func tabBarController(_ viewController: UIViewController? = UIWindow.keyWindow?.rootViewController ) -> UITabBarController? {
        if let viewController = viewController?.presentedViewController {
            return tabBarController(viewController)
        } else if let navigationViewController = viewController as? UINavigationController {
            return tabBarController(navigationViewController.visibleViewController)
        } else if let tabBarController = viewController as? UITabBarController {
            return tabBarController
        } else {
            return nil
        }
    }
}
