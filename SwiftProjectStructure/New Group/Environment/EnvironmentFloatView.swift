//
//  EnvironmentFloatView.swift
//  Environment
//
//  Created by 花生 on 2023/2/27.
//

import UIKit

class EnvironmentFloatView: UILabel {
    
    private static let contentInsets = UIEdgeInsets(top: 80, left: 10, bottom: 80, right: 10)
    private static let itemWidth: CGFloat = 80
    private static let itemHeight: CGFloat = 30
    private static let itemFont = UIFont.systemFont(ofSize: 15)
    
    private var didSelectedClosure: ((Environments) -> ())?
    
    static func show(_ didSelectedClosure: ((Environments) -> ())?) {
        let x = EnvironmentFloatView.contentInsets.left
        let y = EnvironmentFloatView.contentInsets.top
        let width = EnvironmentFloatView.itemWidth
        let height = EnvironmentFloatView.itemHeight
        
        let item = EnvironmentFloatView()
        item.text = EnvironmentManager.shared.environmnet.describe
        item.didSelectedClosure = didSelectedClosure
        item.frame = CGRect(x: x, y: y, width: width, height: height)
        item.font = EnvironmentFloatView.itemFont
        item.textAlignment = .center
        item.isUserInteractionEnabled = true
        item.addGestureRecognizer(UITapGestureRecognizer(target: item, action: #selector(onTapGesture)))
        item.addGestureRecognizer(UIPanGestureRecognizer(target: item, action: #selector(onPanGesture)))
        item.layer.cornerRadius = 5
        item.layer.borderWidth = 1
        item.layer.borderColor = UIColor.lightGray.cgColor
        UIApplication.shared.keyWindow?.addSubview(item)
    }
}

private extension EnvironmentFloatView {
    
    @objc func onTapGesture(_ tapGesture: UITapGestureRecognizer) {
        EnvironmentSelector.show(didSelectedClosure)
    }
    
    @objc func onPanGesture(_ panGesture: UIPanGestureRecognizer) {
        guard let view = panGesture.view else { return }
        if panGesture.state == .changed {
            let point = panGesture.translation(in: view)
            view.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
            panGesture.setTranslation(.zero, in: view)
        } else if panGesture.state == .ended {
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            var centerX = view.center.x
            var centerY = view.center.y
            if view.center.x < width / 2 {
                centerX = view.bounds.width / 2 + EnvironmentFloatView.contentInsets.left
            } else {
                centerX = width - view.bounds.width / 2 - EnvironmentFloatView.contentInsets.right
            }
            if centerY < EnvironmentFloatView.contentInsets.top {
                centerY = EnvironmentFloatView.contentInsets.top
            } else if centerY > height - EnvironmentFloatView.contentInsets.bottom {
                centerY = height - EnvironmentFloatView.contentInsets.bottom
            }
            UIView.animate(withDuration: 0.25) {
                view.center = CGPoint(x: centerX, y: centerY)
            }
        }
    }
}
