//
//  EnvironmentManager.swift
//  Environment
//
//  Created by 花生 on 2023/2/27.
//

import UIKit

public class EnvironmentManager {
    
    public static let shared = EnvironmentManager()

    public var environmnet = Environments.distribute
    
    // 显示浮动标签
    public func register() {
    #if DEBUG
        environmnet = getEnvironment()
        EnvironmentFloatView.show { [weak self] environment in
            guard let `self` = self else { return }
            self.environmnet = environment
            self.setEnvironment(environment)
        }
    #endif
    }
}

private extension EnvironmentManager {
    
    // 设置更改的环境
    func setEnvironment(_ environment: Environments) {
        UserDefaults.standard.set(environment.rawValue, forKey: "KeyEnvironment")
        _ = UserDefaults.standard.synchronize()
    }
    
    // 获取保存的环境
    func getEnvironment() -> Environments {
        let environment = UserDefaults.standard.integer(forKey: "KeyEnvironment")
        return Environments(rawValue: environment) ?? .develop
    }
}
