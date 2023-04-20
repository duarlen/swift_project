//
//  MP4AnimationPlayer.swift
//  AnimationPlayer
//
//  Created by 花生 on 2023/3/20.
//

import Kingfisher
import QGVAPlayer
import UIKit

public class MP4AnimationPlayer: UIView, AnimationPlayerInterface {
    private var player: QGVAPWrapView?
    private let configure: AnimationConfigure
    private let playCompletion: AnimationPlayerCompletion?
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public required init(configure: AnimationConfigure, playCompletion: AnimationPlayerCompletion?) {
        self.configure = configure
        self.playCompletion = playCompletion
        super.init()
    }
    
    public func play() {
        // 获取播放资源
        var sourceFilePath: String!
        if let filePath = configure.resource as? String {
            sourceFilePath = filePath
        } else {
            didEndPlay(error: AnimationError.notSupport)
            return
        }
        
        // 配置
        var contentMode = QGVAPWrapViewContentMode.scaleToFill
        switch configure.contentMode {
        case .scaleToFill:
            contentMode = .scaleToFill
        case .scaleAspectFit:
            contentMode = .aspectFit
        case .scaleAspectFill:
            contentMode = .aspectFill
        default:
            break
        }
        
        // 设置重复次数。这个播放器的 -1 代表无线重复
        var repeatCount = configure.repeatCount
        if repeatCount == 0 {
            repeatCount = -1
        }
        
        // 初始化播放器
        let player = QGVAPWrapView()
        self.player = player
        
        // 配置播放器
        player.contentMode = contentMode
        player.autoDestoryAfterFinish = configure.isClearOnCompletion
        
        // 显示
        player.frame = bounds
        addSubview(player)
        
        // 播放
        player.playHWDMP4(sourceFilePath, repeatCount: repeatCount, delegate: self)
    }
    
    public func clear() {
        if let _ = player {
            player?.stopHWDMP4()
            player?.removeFromSuperview()
        }
    }
    
    private func didEndPlay(error: Error?) {
        clear()
        playCompletion?(error)
    }
}

extension MP4AnimationPlayer: VAPWrapViewDelegate {
    
    // 替换动效资源
    public func vapWrapview_content(forVapTag tag: String, resource info: QGVAPSourceInfo) -> String {
        guard let value = configure.replaceMapper[AnimationReplaceKey.text(tag)] else { return tag }
        switch value {
        case let .text(text):
            return text
        default:
            return tag
        }
    }
    
    // 处理占位的图片
    public func vapWrapView_loadVapImage(withURL urlStr: String, context: [AnyHashable: Any], completion completionBlock: @escaping VAPImageCompletionBlock) {
        guard let url = URL(string: urlStr) else { return }
        KingfisherManager.shared.retrieveImage(with: url) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(res):
                    completionBlock(res.image, nil, urlStr)
                case .failure:
                    completionBlock(UIImage(), nil, urlStr)
                }
            }
        }
    }
    
    public func vapWrap_viewDidFinishPlayMP4(_ totalFrameCount: Int, view container: UIView) {
        didEndPlay(error: nil)
    }
    
    public func vapWrap_viewDidFailPlayMP4(_ error: Error) {
        didEndPlay(error: error)
    }
}
