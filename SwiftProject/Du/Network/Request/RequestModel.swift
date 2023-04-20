//
//  RequestModel.swift
//  Lucky
//
//  Created by 花生 on 2023/3/7.
//

import Foundation
import Moya

public class RequestModel {
    public let path: String
    public let method: RequestMethod
    public let description: String
    public var headers: [String: String] = [:]
    public var parameters: [String: Any] = [:]
    public var enableLogger: Bool = true
    public var timeout: TimeInterval = 30
    
    public init(path: String, method: RequestMethod, description: String) {
        self.path = path
        self.method = method
        self.description = description
    }
}
