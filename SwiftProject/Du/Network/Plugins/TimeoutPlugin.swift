//
//  TimeoutPlugin.swift
//  Networking
//
//  Created by 花生 on 2023/3/30.
//

import Foundation
import Moya

// 设置请求超时的插件
struct TimeoutPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let target = target as? RequestTarget else { return request }
        var request = request
        request.timeoutInterval = target.timeout
        return request
    }
}

