//
//  LottieAnimationPlayer.swift
//  AnimationPlayer
//
//  Created by 花生 on 2023/3/20.
//

import Lottie
import UIKit

public class LottieAnimationPlayer: UIView, AnimationPlayerInterface {
    private var player: Lottie.AnimationView?
    private let configure: AnimationConfigure
    private let playCompletion: AnimationPlayerCompletion?
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public required init(configure: AnimationConfigure, playCompletion: AnimationPlayerCompletion?) {
        self.configure = configure
        self.playCompletion = playCompletion
        super.init()
    }
    
    public func play() {
        // 解析播放资源
        if let url = configure.resource as? URL {
            let player = Lottie.AnimationView(url: url, closure: { [weak self] error in
                guard let `self` = self, let error = error else { return }
                self.didEndPlay(error: error)
            })
            willPlay(player: player)
        } else if let filePath = configure.resource as? String {
            let player = Lottie.AnimationView(filePath: filePath)
            willPlay(player: player)
        } else {
            didEndPlay(error: AnimationError.notSupport)
        }
    }
    
    public func clear() {
        if let _ = player {
            player?.removeFromSuperview()
            player = nil
        }
    }
}

private extension LottieAnimationPlayer {
    func willPlay(player: Lottie.AnimationView) {
        self.player = player
        // 播放次数
        if configure.repeatCount == 0 {
            player.loopMode = .loop
        } else if configure.repeatCount == 1 {
            player.loopMode = .playOnce
        } else {
            player.loopMode = .repeat(Float(configure.repeatCount))
        }
        // 播放内容模式
        player.contentMode = configure.contentMode
        // 添加显示
        player.frame = bounds
        addSubview(player)
        // 播放
        player.play(completion: { [weak self] _ in
            guard let `self` = self else { return }
            self.didEndPlay(error: nil)
        })
    }
    
    func didEndPlay(error: Error?) {
        clear()
        playCompletion?(error)
    }
}
