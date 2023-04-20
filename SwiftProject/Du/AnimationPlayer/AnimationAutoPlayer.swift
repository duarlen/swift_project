//
//  AnimationAutoPlayer.swift
//  AnimationPlayer
//
//  Created by 花生 on 2023/3/24.
//

import Foundation

// 播放器
public class AnimationAutoPlayer {
    
    // 创建一个播放器
    public static func player(with configure: AnimationConfigure, playCompletion: AnimationPlayerCompletion?) -> AnimationPlayerInterface? {
        let animationType = AnimationType(resource: configure.resource)
        switch animationType {
        case .lottie:
            return LottieAnimationPlayer(configure: configure, playCompletion: playCompletion)
        case .svga:
            return SVGAAnimationPlayer(configure: configure, playCompletion: playCompletion)
        case .pag:
            return PAGAnimationPlayer(configure: configure, playCompletion: playCompletion)
        case .mp4:
            return MP4AnimationPlayer(configure: configure, playCompletion: playCompletion)
        case .unowned:
            return nil
        }
    }
}
