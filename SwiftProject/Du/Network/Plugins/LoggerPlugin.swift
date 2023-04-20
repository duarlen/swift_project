//
//  LoggerPlugin.swift
//  Networking
//
//  Created by 花生 on 2023/3/30.
//

import Foundation
import Moya

// 打印日志的插件
struct LoggerPlugin: PluginType {
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        #if DEBUG
            guard let target = target as? RequestTarget, target.enableLogger == true else { return }
            debugPrint("0-0-0-0-0-0-0-0-0-0-0")
            debugPrint("请求链接:", target.path)
            debugPrint("请求参数:", target.parameters ?? [:])
            switch result {
            case let .success(response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data)
                    debugPrint("请求成功:", json)
                } catch let error {
                    debugPrint("请求失败:", error)
                }
            case let .failure(error):
                debugPrint("请求失败:", error)
            }
            debugPrint("1-1-1-1-1-1-1-1-1-1")
        #endif
    }
}
