//
//  PAGAnimationPlayer.swift
//  AnimationPlayer
//
//  Created by 花生 on 2023/3/20.
//

import libpag
import UIKit

public class PAGAnimationPlayer: UIView, AnimationPlayerInterface {
    private let configure: AnimationConfigure
    private let playCompletion: AnimationPlayerCompletion?
    private var player: PAGView?
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public required init(configure: AnimationConfigure, playCompletion: AnimationPlayerCompletion?) {
        self.configure = configure
        self.playCompletion = playCompletion
        super.init()
    }
    
    public func play() {
        // 获取关联文件
        guard let filePath = configure.resource as? String, let file = PAGFile.load(filePath) else {
            didEndPlay(error: AnimationError.notSupport)
            return
        }
        
        // 替换动效资源
        replace(file: file)
        
        // 初始化播放器
        let player = PAGView()
        player.add(self)
        self.player = player
        
        // 设置播放资源
        player.setComposition(file)
        
        // 设置配置
        player.setRepeatCount(Int32(configure.repeatCount))
        player.contentMode = configure.contentMode
        
        // 显示
        player.frame = bounds
        addSubview(player)
        
        // 播放
        player.play()
    }
    
    public func clear() {
        if let _ = player {
            player?.removeFromSuperview()
            player?.remove(self)
            player = nil
        }
    }
    
    private func didEndPlay(error: Error?) {
        clear()
        playCompletion?(error)
    }
}

extension PAGAnimationPlayer: PAGViewListener {
    public func onAnimationEnd(_ pagView: PAGView!) {
        didEndPlay(error: nil)
    }
    
    public func onAnimationCancel(_ pagView: PAGView!) {
        didEndPlay(error: nil)
    }
}

private extension PAGAnimationPlayer {
    // 替换资源
    func replace(file: PAGFile) {
        for (key, value) in configure.replaceMapper {
            switch key {
            case let .index(index):
                replace(file: file, index: Int32(index), replaceData: value)
            case let .text(name):
                replace(file: file, name: name, replaceData: value)
            }
        }
    }
    
    // 替换资源，以名称的形式替换
    func replace(file: PAGFile, name: String, replaceData: AnimationReplaceData) {
        switch replaceData {
        case let .text(text):
            if let index = file.getLayersByName(name).first?.editableIndex(), let pageText = file.getTextData(Int32(index)) {
                pageText.text = text
                file.replaceText(Int32(index), data: pageText)
            }
        case let .image(image):
            if let cgImage = image?.cgImage, let pagImage = PAGImage.fromCGImage(cgImage) {
                file.replaceImage(byName: name, data: pagImage)
            }
        default:
            break
        }
    }
    
    // 替换资源，以索引的形式替换
    func replace(file: PAGFile, index: Int32, replaceData: AnimationReplaceData) {
        switch replaceData {
        case let .text(text):
            if let pageText = file.getTextData(index) {
                pageText.text = text
                file.replaceText(index, data: pageText)
            }
        case let .image(image):
            if let cgImage = image?.cgImage, let pagImage = PAGImage.fromCGImage(cgImage) {
                file.replaceImage(index, data: pagImage)
            }
        default:
            break
        }
    }
}
