//
//  AnimationPlayerInterface.swift
//  AnimationPlayer
//
//  Created by 花生 on 2023/3/20.
//

import UIKit

// 动画播放结束
public typealias AnimationPlayerCompletion = (Error?) -> Void

// 动画播放器接口
public protocol AnimationPlayerInterface: UIView {
    // 初始化播放器
    init(configure: AnimationConfigure, playCompletion: AnimationPlayerCompletion?)

    // 播放
    func play()

    // 清理
    func clear()
}
