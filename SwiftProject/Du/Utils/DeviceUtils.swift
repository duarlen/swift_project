
import UIKit
import AdSupport

// 屏幕宽度
var ScreenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

// 屏幕高度
var ScreenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

// 顶部安全距离
var SafeHeightToTop: CGFloat {
    return DeviceUtils.safeHeightToTop()
}

// 底部安全距离
var SafeHeightToBottom: CGFloat {
    return DeviceUtils.safeHeightToBottom()
}

// 状态栏高度
var StatusBarHeight: CGFloat {
    return DeviceUtils.statusBarHeight()
}

// 导航条高度
var NavigationBarHeight: CGFloat {
    return DeviceUtils.navigationBarHeight()
}

class DeviceUtils {
    
}

private extension DeviceUtils {
    
    // 顶部安全距离
    static func safeHeightToTop() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene, let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.top
        } else {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.top
        }
    }
    
    // 底部安全距离
    static func safeHeightToBottom() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene, let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        } else {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        }
    }
    
    // 状态栏高度
    static func statusBarHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            if let height = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height {
                return height
            }
            return UIApplication.shared.statusBarFrame.height
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    // 导航条高度
    static func navigationBarHeight() -> CGFloat {
        return statusBarHeight() + 44
    }
    
    // 当前设备的 IDFA
    static var IDFA: String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    // 当前设备的 IDFV
    static var IDFV: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    // 当前设备的 UUID
    static var UUID: String {
        return NSUUID().uuidString
    }
    
    // 当前设备的名字
    static var deviceName: String {
        return UIDevice.current.name
    }
    
    // 当前设备的系统名字
    static var systemName: String {
        return UIDevice.current.systemName
    }
    
    // 当前设备的系统版本号
    static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    // 当前设备是否为 iphone
    static var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    // 当前设备是否为 ipad
    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // 当前设备型号
    static var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
            
            // iphone
        case "iPhone7,1":
            return "iPhone 6 Plus"
        case "iPhone7,2":
            return "iPhone 6"
        case "iPhone8,1":
            return "iPhone 6s"
        case "iPhone8,2":
            return "iPhone 6s Plus"
        case "iPhone8,4":
            return "iPhone SE (1st generation)"
        case "iPhone9,1", "iPhone9,3":
            return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":
            return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":
            return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":
            return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":
            return "iPhone X"
        case "iPhone11,2":
            return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":
            return "iPhone XS Max"
        case "iPhone11,8":
            return "iPhone XR"
        case "iPhone12,1":
            return "iPhone 11"
        case "iPhone12,3":
            return "iPhone 11 Pro"
        case "iPhone12,5":
            return "iPhone 11 Pro Max"
        case "iPhone12,8":
            return "iPhone SE (2nd generation)"
        case "iPhone13,1":
            return "iPhone 12 mini"
        case "iPhone13,2":
            return "iPhone 12"
        case "iPhone13,3":
            return "iPhone 12 Pro"
        case "iPhone13,4":
            return "iPhone 12 Pro Max"
        case "iPhone14,4":
            return "iPhone 13 mini"
        case "iPhone14,5":
            return "iPhone 13"
        case "iPhone14,2":
            return "iPhone 13 Pro"
        case "iPhone14,3":
            return "iPhone 13 Pro Max"
        case "iPhone14,6":
            return "iPhone SE (3rd generation)"
        case "iPhone14,7":
            return "iPhone 14"
        case "iPhone14,8":
            return "iPhone 14 Plus"
        case "iPhone15,2":
            return "iPhone 14 Pro"
        case "iPhone15,3":
            return "iPhone 14 Pro Max"
        
            // ipod
        case "iPod1,1":
            return "iPod Touch"
        case "iPod2,1":
            return "iPod touch (2nd generation)"
        case "iPod3,1":
            return "iPod touch (3rd generation)"
        case "iPod4,1":
            return "iPod touch (4th generation)"
        case "iPod5,1":
            return "iPod touch (5th generation)"
        case "iPod7,1":
            return "iPod touch (6th generation)"
        case "iPod9,1":
            return "iPod touch (7th generation)"
            
            // ipad
        case "iPad1,1":
            return "iPad"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":
            return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":
            return "iPad (3rd generation)"
        case "iPad3,4", "iPad3,5", "iPad3,6":
            return "iPad (4th generation)"
        case "iPad4,1", "iPad4,2", "iPad4,3":
            return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":
            return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":
            return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":
            return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":
            return "iPad Air 2"
        case "iPad6,3", "iPad6,4":
            return "iPad Pro (9.7-inch)"
        case "iPad6,7", "iPad6,8":
            return "iPad Pro (12.9-inch)"
        case "iPad6,11", "iPad6,12":
            return "iPad (5th generation)"
        case "iPad7,1", "iPad7,2":
            return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad7,3", "iPad7,4":
            return "iPad Pro (10.5-inch)"
        case "iPad7,5", "iPad7,6":
            return "iPad (6th generation)"
        case "iPad7,11", "iPad7,12":
            return "iPad (7th generation)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":
            return "iPad Pro (11-inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":
            return "iPad Pro (12.9-inch) (3rd generation)"
        case "iPad8,9", "iPad8,10":
            return "iPad Pro (11-inch) (2nd generation)"
        case "iPad8,11", "iPad8,12":
            return "iPad Pro (12.9-inch) (4th generation)"
        case "iPad11,1", "iPad11,2":
            return "iPad mini (5th generation)"
        case "iPad11,3", "iPad11,4":
            return "iPad Air (3rd generation)"
        case "iPad11,6", "iPad11,7":
            return "iPad (8th generation)"
        case "iPad12,1", "iPad12,2":
            return "iPad (9th generation)"
        case "iPad13,1", "iPad13,2":
            return "iPad Air (4th generation)"
        case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":
            return "iPad Pro (11-inch) (3rd generation)"
        case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":
            return "iPad Pro (12.9-inch) (5th generation)"
        case "iPad13,16", "iPad13,17":
            return "iPad Air (5th generation)"
        case "iPad13,18", "iPad13,19":
            return "iPad (10th generation)"
        case "iPad14,1", "iPad14,2":
            return "iPad mini (6th generation)"
        case "iPad14,3", "iPad14,4":
            return "iPad Pro (11-inch) (4rd generation)"
        case "iPad14,5", "iPad14,6":
            return "iPad Pro (12.9-inch) (6rd generation)"
        case "i386", "x86_64":
            return "Simulator"
            
        default:
            return identifier
        }
    }
}
