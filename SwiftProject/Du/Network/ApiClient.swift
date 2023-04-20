//
//  ApiClient.swift
//  Networking
//
//  Created by 花生 on 2023/3/30.
//

import Moya
import RxSwift
import UIKit

public class ApiClient {
    
    // api 对象
    public static let share = ApiClient()
    
    private let provider = MoyaProvider<MultiTarget>(plugins: [
        LoggerPlugin(),
        TimeoutPlugin(),
    ])
}

public extension ApiClient {
    
    // 以 Result 的形式返回响应数据
    func request<T>(_ model: RequestModel, type: T.Type, completion: ((Result<ResponseModel<T>, Error>) -> Void)?) {
        _ = request(model, type: type).subscribe(onSuccess: { model in
            completion?(Result<ResponseModel<T>, Error>.success(model))
        }, onFailure: { error in
            completion?(Result<ResponseModel<T>, Error>.failure(error))
        })
    }

    // 以信号的形式返回请求结果
    func request<T>(_ model: RequestModel, type: T.Type) -> Single<ResponseModel<T>> {
        let target = RequestTarget(model: model)
        return provider.rx.request(MultiTarget(target)).mapResponseModel(type)
    }
}
