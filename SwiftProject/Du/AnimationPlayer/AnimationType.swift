//
//  AnimationType.swift
//  AnimationPlayer
//
//  Created by 花生 on 2023/3/24.
//

import Foundation

// 动画类型
enum AnimationType {
    case lottie // Lottie 动画
    case svga // svaga 动画
    case pag // pag 动画
    case mp4 // mp4 动画
    case unowned // 未知的
}

extension AnimationType {
    
    // 根据动画资源获取对应的动画类型
    init(resource: AnimationResource) {
        if let filePath = resource as? String {
            self.init(extensionName: URL(fileURLWithPath: filePath).pathExtension)
        } else if let url = resource as? URL {
            self.init(extensionName: url.pathExtension)
        } else {
            self = .unowned
        }
    }
    
    // 根据扩展名获取对应的动画类型
    init(extensionName: String) {
        if AnimationType.lottie.extensionNames.contains(extensionName) {
            self = .lottie
        } else if AnimationType.svga.extensionNames.contains(extensionName) {
            self = .svga
        } else if AnimationType.pag.extensionNames.contains(extensionName) {
            self = .pag
        } else if AnimationType.mp4.extensionNames.contains(extensionName) {
            self = .mp4
        } else {
            self = .unowned
        }
    }
}

private extension AnimationType {
    // 对应动画类型对应的扩展名
    var extensionNames: [String] {
        switch self {
        case .lottie:
            return ["json"]
        case .svga:
            return ["svga"]
        case .pag:
            return ["pag"]
        case .mp4:
            return ["mp4"]
        case .unowned:
            return []
        }
    }
}
