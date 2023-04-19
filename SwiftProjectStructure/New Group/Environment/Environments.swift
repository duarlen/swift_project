//
//  Environments.swift
//  Alamofire
//
//  Created by 花生 on 2023/2/24.
//

import UIKit

public enum Environments: Int, CaseIterable {
    case develop = 0
    case distribute = 1
    
    var describe: String {
        switch self {
        case .develop:
            return "开发环境"
        case .distribute:
            return "正式环境"
        }
    }
    
}


