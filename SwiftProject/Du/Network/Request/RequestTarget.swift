//
//  RequestTarget.swift
//  Networking
//
//  Created by 花生 on 2023/3/30.
//

import Moya
import UIKit

struct RequestTarget: TargetType {
    let baseURL: URL
    let path: String
    let method: Moya.Method
    let task: Moya.Task
    let headers: [String: String]?
    let parameters: [String: Any]?
    let timeout: TimeInterval
    let enableLogger: Bool

    init(model: RequestModel) {
        baseURL = URL(string: "https://www.baidu.com")!
        path = model.path
        headers = model.headers
        parameters = model.parameters
        task = Moya.Task.requestParameters(parameters: model.parameters, encoding: JSONEncoding.default)
        timeout = model.timeout
        enableLogger = model.enableLogger
        switch model.method {
        case .GET:
            method = Moya.Method.get
        case .POST:
            method = Moya.Method.post
        }
    }
}
