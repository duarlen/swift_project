//
//  ResponseModel.swift
//  KYNetworking
//
//  Created by 花生 on 2023/2/24.
//

import Foundation
import HandyJSON

// 基础数据模型
public class ResponseModel<T>: HandyJSON {
    
    public var code: String = ""        // 状态码
    public var success: Bool = true     // 成功
    public var msg: String = ""         // 错误信息
    public var data: T?
    
    public required init() { }
}
