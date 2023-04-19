//
//  EnvironmentSelector.swift
//  Environment
//
//  Created by 花生 on 2023/2/24.
//

import SnapKit
import UIKit

class EnvironmentSelector: UIView {
    private let backgroundView = UIView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    private var didSelectedClosure: ((Environments) -> Void)?

    static func show(_ didSelectedClosure: ((Environments) -> Void)?) {
        let EnvironmentSelector = EnvironmentSelector()
        EnvironmentSelector.didSelectedClosure = didSelectedClosure
        EnvironmentSelector.frame = UIScreen.main.bounds
        EnvironmentSelector.setupUI()
        let window = UIApplication.shared.keyWindow?.addSubview(EnvironmentSelector)
        EnvironmentSelector.layoutIfNeeded()
        EnvironmentSelector.show()
    }
}

private extension EnvironmentSelector {
    func setupUI() {
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        backgroundView.alpha = 0
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onHide)))
        addSubview(backgroundView)
        
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        addSubview(contentView)
        
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        contentView.addSubview(stackView)
        
        for environment in Environments.allCases {
            let item = buildItem(title: environment.describe, isSelected: environment == EnvironmentManager.shared.environmnet)
            item.tag = environment.rawValue
            item.addTarget(self, action: #selector(onSelected), for: .touchUpInside)
            item.layer.borderWidth =  0.5
            item.layer.borderColor = UIColor.lightGray.cgColor
            stackView.addArrangedSubview(item)
            item.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
        }
        
        setupLayout()
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.top)
            make.left.right.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.left.right.bottom.equalTo(contentView)
        }
    }
    
    @objc func onSelected(_ item: UIButton) {
        guard let environment = Environments(rawValue: item.tag) else { return }
        self.hide {
            self.didSelectedClosure?(environment)
        }
    }
    
    @objc func onHide() {
        self.hide(nil)
    }
    
    func show() {
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 1
            self.contentView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.left.right.equalToSuperview()
            }
            self.layoutIfNeeded()
        }
    }
    
    func hide(_ completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.alpha = 0
            self.contentView.snp.remakeConstraints { make in
                make.bottom.equalTo(self.snp.top)
                make.left.right.equalToSuperview()
            }
            self.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
            completion?()
        })
    }
    
    func buildItem(title: String, isSelected: Bool) -> UIControl {
        let item = UIControl()
        
        let lable1 = UILabel()
        lable1.text = title
        item.addSubview(lable1)
        lable1.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        if isSelected {
            let lable2 = UILabel()
            lable2.text = "√"
            item.addSubview(lable2)
            lable2.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(60)
                make.centerY.equalToSuperview()
            }
        }
        return item
    }
}
