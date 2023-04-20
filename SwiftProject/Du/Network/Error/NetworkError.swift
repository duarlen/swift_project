//
//  NetworkError.swift
//  KYNetworking
//
//  Created by 花生 on 2023/2/24.
//

import Foundation

public enum NetworkError: Error {
    case unknown    // 未知错误。
    case noNetwork  // 无网络链接。（没有网络时）
    case invalid    // 无效的数据。（数据解析失败等）
    case api(message: String) // api调用错误。（后端返回的错误信息）
}

extension NetworkError {
    var localizedDescription: String {
        switch self {
        case .unknown:
            return "未知错误"
        case .noNetwork:
            return "网络未连接"
        case .invalid:
            return "无效的数据"
        case .api(let message):
            return message
        }
    }
}


// 解析 `MoyaError` 为 `NetworkError`
//public extension Error {
//    var networkError: NetworkError {
//        if let error = self as? NetworkError { return error }
//        let code = ((self as? MoyaError)?.errorUserInfo[NSUnderlyingErrorKey] as? NSError)?.code
//        if code == -1009 { return NetworkError.noNetwork }
//        return NetworkError.unknown
//    }
//}




/*
     NSError codes in the Cocoa error domain.
     
     enum {
     NSFileNoSuchFileError = 4,  // 文件不存在
     NSFileLockingError = 255,  // 未能得到一个锁文件
     NSFileReadUnknownError = 256,   // 读取错误,原因不明
     NSFileReadNoPermissionError = 257, // 读取错误是因为权限问题
     NSFileReadInvalidFileNameError = 258, // 读取错误,因为一个无效的文件名
     NSFileReadCorruptFileError = 259,  // 读取错误,因为一个损坏的文件,错误的格式,或类似的原因
     NSFileReadNoSuchFileError = 260,  // 读取错误,因为没有这样的文件
     NSFileReadInapplicableStringEncodingError = 261,  // 读取错误,因为字符串编码并不适用。
     NSFileReadUnsupportedSchemeError = 262,  // 读取错误,因为指定的URL方案是不支持的
     NSFileReadTooLargeError = 263, //  指定读取错误,因为文件太大。
     NSFileReadUnknownStringEncodingError = 264, // 文件读取错误,因为字符串编码无法确定
     NSFileWriteUnknownError = 512,  // 写错误,原因不明
     NSFileWriteNoPermissionError = 513,  // 写错误,因为权限问题
     NSFileWriteInvalidFileNameError = 514,  // 写错误,因为一个无效的文件名
     NSFileWriteInapplicableStringEncodingError = 517,  // 写错误,因为字符串编码并不适用。
     NSFileWriteUnsupportedSchemeError = 518,  // 写错误,因为指定的URL方案是不支持的
     NSFileWriteOutOfSpaceError = 640,  // 写错误,因为缺少磁盘空间
     NSFileWriteVolumeReadOnlyError = 642 // 写错误,因为体积是只读的。
     NSKeyValueValidationError = 1024,  // 键值编码验证错误
     NSFormattingError = 2048,  // 格式错误(显示相关数据)
     NSUserCancelledError = 3072, // 用户取消了操作(例如,按下Command-period)。这段代码是错误不需要一个对话框显示为代价和可能的候选人。
     
     NSFileErrorMinimum = 0, // 标志着开始的一系列错误代码保留文件错误
     NSFileErrorMaximum = 1023, // 标志着结束的一系列错误代码保留文件错误
     NSValidationErrorMinimum = 1024,  // 标志着开始的一系列错误代码用于验证错误。
     NSValidationErrorMaximum = 2047,  // 标志的开始和结束的范围错误代码用于验证错误。
     NSFormattingErrorMinimum = 2048, // 标志着开始的一系列错误代码用于格式化错误。
     NSFormattingErrorMaximum = 2559,  // 标志着结束的范围错误代码用于格式化错误。
     
     NSPropertyListReadCorruptError = 3840,  // 错误的出处,同时解析属性列表。
     NSPropertyListReadUnknownVersionError = 3841,  // 版本号的属性列表无法确定。
     NSPropertyListReadStreamError = 3842,  // 一个流错误阅读时遇到的属性列表。
     NSPropertyListWriteStreamError = 3851,  // 一个流的错误在写作时所遇到的属性列表。
     NSPropertyListErrorMinimum = 3840,  // 标志着开始的一系列错误代码留给属性列表错误。
     NSPropertyListErrorMaximum = 4095,  // 标志着结束的范围错误代码留给属性列表错误。
     
     NSExecutableErrorMinimum = 3584,  // 标志着开始的一系列错误代码保留错误相关的可执行文件。
     NSExecutableNotLoadableError = 3584,  // 可执行的类型不是可加载在当前过程。
     NSExecutableArchitectureMismatchError = 3585,  // 可执行文件没有提供一个架构兼容当前进程。
     NSExecutableRuntimeMismatchError = 3586,  // 可执行目标C运行时信息不符合当前进程。
     NSExecutableLoadError = 3587,  // 无法加载，因为一些其他的原因
     NSExecutableLinkError = 3588,  // 可执行的失败由于连接问题。
     
     NSExecutableErrorMaximum = 3839, // 标志着结束的范围错误代码保留错误相关的可执行文件。
     
     }
     URL Loading System Error Codes
     
     These values are returned as the error code property of an NSError object with the domain “NSURLErrorDomain”.
     
     typedef enum
     {
     NSURLErrorUnknown = -1,   // "无效的URL地址"
     NSURLErrorCancelled = -999,  // "无效的URL地址"
     NSURLErrorBadURL = -1000,  // "无效的URL地址"
     NSURLErrorTimedOut = -1001,  // "网络不给力，请稍后再试"
     NSURLErrorUnsupportedURL = -1002,  // "不支持的URL地址"
     NSURLErrorCannotFindHost = -1003,  // "找不到服务器"
     NSURLErrorCannotConnectToHost = -1004,  // "连接不上服务器"
     NSURLErrorDataLengthExceedsMaximum = -1103,  // "请求数据长度超出最大限度"
     NSURLErrorNetworkConnectionLost = -1005,  // "网络连接异常"
     NSURLErrorDNSLookupFailed = -1006,  // "DNS查询失败"
     NSURLErrorHTTPTooManyRedirects = -1007,  // "HTTP请求重定向"
     NSURLErrorResourceUnavailable = -1008,  // "资源不可用"
     NSURLErrorNotConnectedToInternet = -1009,  // "无网络连接"
     NSURLErrorRedirectToNonExistentLocation = -1010,  // "重定向到不存在的位置"
     NSURLErrorBadServerResponse = -1011,  // "服务器响应异常"
     NSURLErrorUserCancelledAuthentication = -1012,  // "用户取消授权"
     NSURLErrorUserAuthenticationRequired = -1013,  // "需要用户授权"
     NSURLErrorZeroByteResource = -1014,  // "零字节资源"
     NSURLErrorCannotDecodeRawData = -1015,  // "无法解码原始数据"
     NSURLErrorCannotDecodeContentData = -1016,  // "无法解码内容数据"
     NSURLErrorCannotParseResponse = -1017,  // "无法解析响应"
     NSURLErrorInternationalRoamingOff = -1018, // "国际漫游关闭"
     NSURLErrorCallIsActive = -1019, // "被叫激活"
     NSURLErrorDataNotAllowed = -1020, // "数据不被允许"
     NSURLErrorRequestBodyStreamExhausted = -1021, // "请求体"
     NSURLErrorFileDoesNotExist = -1100,  // "文件不存在"
     NSURLErrorFileIsDirectory = -1101,  // "文件是个目录"
     NSURLErrorNoPermissionsToReadFile = -1102,  // "无读取文件权限"
     NSURLErrorSecureConnectionFailed = -1200,  // "安全连接失败"
     NSURLErrorServerCertificateHasBadDate = -1201,  // "服务器证书失效"
     NSURLErrorServerCertificateUntrusted = -1202, // "不被信任的服务器证书"
     NSURLErrorServerCertificateHasUnknownRoot = -1203,  // "未知Root的服务器证书"
     NSURLErrorServerCertificateNotYetValid = -1204,  // "服务器证书未生效"
     NSURLErrorClientCertificateRejected = -1205,  // "客户端证书被拒"
     NSURLErrorClientCertificateRequired = -1206,  // "需要客户端证书"
     NSURLErrorCannotLoadFromNetwork = -2000,  // "无法从网络获取"
     NSURLErrorCannotCreateFile = -3000,  // "无法创建文件"
     NSURLErrorCannotOpenFile = -3001,  // "无法打开文件"
     NSURLErrorCannotCloseFile = -3002,  // "无法关闭文件"
     NSURLErrorCannotWriteToFile = -3003,  // "无法写入文件"
     NSURLErrorCannotRemoveFile = -3004, // "无法删除文件"
     NSURLErrorCannotMoveFile = -3005,  // "无法移动文件"
     NSURLErrorDownloadDecodingFailedMidStream = -3006,  // "下载解码数据失败"
     NSURLErrorDownloadDecodingFailedToComplete = -3007  // "下载解码数据失败"
 }
 
 */
