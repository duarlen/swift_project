//
//  LocalDataUtils.swift
//  LocalDataUtils
//
//  Created by 花生 on 2023/2/24.
//


import Foundation

//. 本地数据存储工具
/// 注：数据存储在 UserDefaults 中
/// 目录结构：
/// Root
/// ┃
/// └ ━ Common 公共数据表（不以用户为目标区分）
/// ┃
/// └ ━ User1 用户 1 数据表（以用户为目标区分的数据）
/// ┃
/// └ ━ User2 用户 2 数据表（以用户为目标区分的数据）
///     ...
public class LocalDataUtils {
    
    // 存储本地数据的根 key
    private static let localDataRootKey = "UserLocalDataRootKey"
    
    // 公共用户数据 key
    private static let commonDataKey = "Common"
    
    // 用户id （保存的数据以用户维度的时候，使用用户id）
    public static var currentUserId: String?
}

// `获取/设置`用户数据
public extension LocalDataUtils {
    
    /// 获取用户存储的数据
    /// - Parameters:
    ///   - key: 用户存储的 key
    ///   - isCommon: 是否为公共数据。默认 true
    /// - Returns: 对应的数据
    static func data<T>(for key: String, isCommon: Bool = true) -> T? {
        let userMap = getUserMap(isCommon)
        let data = userMap[key] as? T
        return data
    }
    
    /// 设置用户数据
    /// - Parameters:
    ///   - key: 设置数据的key
    ///   - data: 设置的数据
    ///   - isCommon: 是否为公共数据。默认 true
    static func update(key: String, data: Any, isCommon: Bool = true) {
        var userMap = getUserMap(isCommon)
        userMap[key] = data
        updateUserMap(userMap, isCommon: isCommon)
    }
}

//  用户字典操作
private extension LocalDataUtils {
    
    // 获取 root map
    static func getRootMap() -> [String: Any] {
        if let map = UserDefaults.standard.object(forKey: LocalDataUtils.localDataRootKey) as? [String: Any] {
            return map
        }
        let map: [String: Any] = [:]
        updateRootMap(map)
        return map
    }
    
    // 设置 root map
    static func updateRootMap(_ map: [String: Any]) {
        let ud = UserDefaults.standard
        ud.set(map, forKey: LocalDataUtils.localDataRootKey)
        _ = ud.synchronize()
    }
    
    /// 获取用户key
    static func getUserKey(_ isCommon: Bool) -> String {
        if isCommon == false, let currentUserId = self.currentUserId, currentUserId.count > 0 {
            return currentUserId
        }
        return LocalDataUtils.commonDataKey
    }
        
    /// 获取用户的数据表
    static func getUserMap(_ isCommon: Bool) -> [String: Any] {
        let key = getUserKey(isCommon)
        let rootMap = getRootMap()
        if let userMap = rootMap[key] as? [String: Any] {
            return userMap
        }
        let userMap: [String: Any] = [:]
        updateUserMap(userMap, isCommon: isCommon)
        return userMap
    }
    
    /// 更新用户数据表
    static func updateUserMap(_ userMap: [String: Any], isCommon: Bool) {
        let key = getUserKey(isCommon)
        var rootMap = getRootMap()
        rootMap[key] = userMap
        updateRootMap(rootMap)
    }
}
