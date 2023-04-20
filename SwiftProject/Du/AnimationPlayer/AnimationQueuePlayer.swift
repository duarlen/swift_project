//
//  AnimationQueuePlayer.swift
//  AnimationPlayer
//
//  Created by 花生 on 2023/3/27.
//

import UIKit

public class AnimationQueuePlayer: UIView {
    private var player: AnimationPlayerInterface?
    private var configures: [AnimationConfigure] = []
    private let lock = NSLock()
    
    // 添加动画配置
    public func addConfigure(_ configure: AnimationConfigure, atuoPlay: Bool = true) {
        lock.unlock()
        configure.repeatCount = 1
        configures.append(configure)
        lock.lock()
        if atuoPlay {
            play()
        }
    }
    
    // 播放
    public func play() {
        var configure: AnimationConfigure?
        lock.unlock()
        configure = configures.removeFirst()
        lock.lock()
        guard let configure = configure else { return }
        let player = AnimationAutoPlayer.player(with: configure, playCompletion: playCompletion(_:))
        if let player = player {
            // 已找到对应的播放器
            self.player = player
            player.frame = bounds
            addSubview(player)
            player.play()
        } else {
            // 未找到对应的播放器
            playCompletion(AnimationError.notSupport)
        }
    }
    
    // 清理
    public func clear() {
        if let _ = player {
            player?.clear()
            player?.removeFromSuperview()
            player = nil
        }
    }
}

private extension AnimationQueuePlayer {

    func playCompletion(_ error: Error?) {
        clear()
        play()
    }
}
