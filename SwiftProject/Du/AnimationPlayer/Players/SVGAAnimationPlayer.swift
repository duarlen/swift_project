//
//  SVGAAnimationPlayer.swift
//  AnimationPlayer
//
//  Created by 花生 on 2023/3/20.
//

import SVGAPlayer
import UIKit

public class SVGAAnimationPlayer: UIView, AnimationPlayerInterface {
    private var player: SVGAPlayer?
    private var parser: SVGAParser?
    private let playCompletion: AnimationPlayerCompletion?
    private let configure: AnimationConfigure

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public required init(configure: AnimationConfigure, playCompletion: AnimationPlayerCompletion?) {
        self.configure = configure
        self.playCompletion = playCompletion
        super.init()
    }

    public func play() {
        var sourceURL: URL!
        if let url = configure.resource as? URL {
            sourceURL = url
        } else if let filePath = configure.resource as? String {
            sourceURL = URL(fileURLWithPath: filePath)
        } else {
            didEndPlay(error: AnimationError.notSupport)
            return
        }

        // 初始化播放器
        let player = SVGAPlayer()
        let parser = SVGAParser()
        self.player = player
        self.parser = parser

        // 配置
        player.delegate = self
        player.clearsAfterStop = configure.isClearOnCompletion
        player.loops = Int32(configure.repeatCount)
        player.contentMode = configure.contentMode

        // 显示
        player.frame = bounds
        addSubview(player)

        // 解析并播放
        parser.parse(with: sourceURL) { [weak self] entity in
            guard let `self` = self else { return }
            if let entity = entity {
                // 设置播放资源
                player.videoItem = entity
                
                // 替换动效资源
                for (key, value) in self.configure.replaceMapper {
                    switch key {
                    case .index:
                        break
                    case let .text(text):
                        switch value {
                        case let .text(text):
                            player.setAttributedText(NSAttributedString(string: text), forKey: text)
                        case let .attributedText(attributedText):
                            player.setAttributedText(attributedText, forKey: text)
                        case let .image(image):
                            if let image = image {
                                player.setImage(image, forKey: text)
                            }
                        case .imageUrl:
                            break
                        }
                    }
                }
                
                // 开始播放
                player.startAnimation()
            } else {
                self.didEndPlay(error: AnimationError.notSupport)
            }
        } failureBlock: { [weak self] error in
            guard let `self` = self else { return }
            self.didEndPlay(error: error)
        }
    }

    public func clear() {
        if let _ = player {
            player?.stopAnimation()
            player?.clear()
            player?.removeFromSuperview()
            player = nil
        }
        if let _ = parser {
            parser = nil
        }
    }

    private func didEndPlay(error: Error?) {
        clear()
        playCompletion?(error)
    }
}

extension SVGAAnimationPlayer: SVGAPlayerDelegate {
    public func svgaPlayerDidFinishedAnimation(_ player: SVGAPlayer!) {
        guard player == player else { return }
        didEndPlay(error: nil)
    }
}
