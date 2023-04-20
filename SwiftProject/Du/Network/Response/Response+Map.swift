//
//  Response+Map.swift
//  Networking
//
//  Created by 花生 on 2023/3/30.
//

import Foundation
import Moya
import RxSwift
import HandyJSON

/* 正常使用 */
/* 响应数据转换为数据模型 */

public extension Response {
    func mapResponseModel<T>(_ type: T.Type) throws -> ResponseModel<T> {
        let jsonString = String(data: data, encoding: .utf8)
        guard (200 ... 299).contains(statusCode) else { throw NetworkError.invalid }
        guard let model = ResponseModel<T>.deserialize(from: jsonString) else { throw NetworkError.invalid }
        if model.code != "200" { throw NetworkError.api(message: model.msg) }
        return model
    }
}

/* 配合 RxSwift */
/* 响应数据转换为数据模型: */

public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func mapResponseModel<T>(_ type: T.Type) -> Single<ResponseModel<T>> {
        return flatMap { Single.just(try $0.mapResponseModel(type)) }
    }
}
