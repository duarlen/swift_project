//
//  AnimationError.swift
//  AnimationPlayer
//
//  Created by 花生 on 2023/3/24.
//

import Foundation

public enum AnimationError: Error {
    // 不支持的资源类型
    case notSupport
}

extension AnimationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notSupport:
            return "不支持的资源类型"
        }
    }
}
