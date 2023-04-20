//
//  AnimationConfigure.swift
//  AnimationPlayer
//
//  Created by 花生 on 2023/3/20.
//

import UIKit

// 动效资源类型
public protocol AnimationResource {}

// 动效路径
public typealias AnimationFilePath = String
extension AnimationFilePath: AnimationResource {}

// 动效链接
public typealias AnimationUrl = URL
extension AnimationUrl: AnimationResource {}


/// 动效替换资源的key
/// 有两种形式
/// 形式1：以`索引`的形式。其中PAG格式的资源就是有以索引的形式展示
/// 形式2：以`字符串`的形式。大部分都是以字符串的形式展示
public enum AnimationReplaceKey: Hashable {
    case index(_ index: Int)
    case text(_ text: String)
}

/// 动效需要替换的资源类型
/// 有四种形式
/// 1. 文本类型
/// 2. 富文本类型
/// 3. 图片类型
/// 4. 图片链接类型
public enum AnimationReplaceData {
    // 字符串类型
    case text(_ text: String)

    // 富文本类型
    case attributedText(_ attributedText: NSAttributedString)

    // 图片资源类型
    case image(_ image: UIImage?)

    // 图片链接类型
    case imageUrl(_ image: String)
}

// 动效的配置
public class AnimationConfigure {
    /// 播放资源
    public var resource: AnimationResource
    
    /// 替换资源列表
    public var replaceMapper: [AnimationReplaceKey : AnimationReplaceData]
    
    /// 配置的播放次数。 注：0：代表无限次
    public var repeatCount: Int
    
    /// 播放完成后自动清理。
    public var isClearOnCompletion: Bool
    
    /// 内容填充模式
    public var contentMode: UIView.ContentMode

    // 初始化
    public init(resource: AnimationResource, replaceMapper: [AnimationReplaceKey : AnimationReplaceData], repeatCount: Int = 1, isClearOnCompletion: Bool = true, contentMode: UIView.ContentMode = .scaleAspectFill) {
        self.resource = resource
        self.replaceMapper = replaceMapper
        self.repeatCount = repeatCount
        self.isClearOnCompletion = isClearOnCompletion
        self.contentMode = contentMode
    }
}
