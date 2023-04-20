
import Foundation

//MARK: --- 字符串截取
public extension String {
    
    /// 截取：中间
    func subString(from: Int, to: Int) -> String {
        return String(self[index(startIndex, offsetBy: from) ..< index(startIndex, offsetBy: to)])
    }
    
    /// 截取：前N位
    func substring(to: Int) -> String {
        return subString(from: 0, to: to)
    }
    
    /// 截取：后 N 为
    func substring(from: Int) -> String {
        return subString(from: from, to: count)
    }
    
    /// 截取：中间
    func substring(with range: NSRange) -> String {
        return subString(from: range.location, to: range.location + range.length)
    }
}

//MARK: --- 字符串转拼音
public extension String {
    
    // 转换为拼音
    var toPinYin: String {
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    // 获取首字母
    var firstPinYinLetter: String {
        let pinyin = toPinYin
        if pinyin.isEmpty { return "" }
        return pinyin.substring(to: 1)
    }
}

// MARK: --- 字符串与正则
public extension String {
    
    /// 是否匹配一个正则
    func isMatch(_ pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let results = regex.matches(in: self, options: .reportProgress, range: NSRange(location: 0, length: count))
            return results.count > 0
        } catch _ {
            return false
        }
    }
    
    // 邮箱：是否为邮箱
    var isEmail: Bool {
        return isMatch("^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$")
    }
    
    // 手机号码：是否为手机号码
    var isPhoneNumber: Bool {
        return isMatch("^1\\d{10}$")
    }
    
    // 是否为身份证号
    var isIDCard: Bool {
        return isMatch("^\\d{15}|\\d{18}$")
    }
    
    // 是否为全中文
    var isChinese: Bool {
        return isMatch("[\\u4e00-\\u9fa5]")
    }
    
    // 是否全数字
    var isNumber: Bool {
        return isMatch("^[0-9]*$")
    }
    
    // 是否英文
    var isEnglish: Bool {
        return isMatch("^[A-Za-z]+$")
    }
    
    // 是否为英文+数字
    var isEnglishNumber: Bool {
        return isMatch("^[A-Za-z0-9]+$")
    }
}

//MARK: --- 字符串与表情
public extension String {
    
    /// 表情：是否包含
    var isContainEmoji: Bool {
        return contains{ $0.isEmoji }
    }
    
    /// 表情：是否为一个表情
    var isSingleEmoji: Bool {
        return count == 1 && isContainEmoji
    }
    
    /// 表情：是否只包含表情
    var isOnlyContainEmoji: Bool {
        return !isEmpty && !contains{ !$0.isEmoji }
    }
    
    /// 表情：所有的表情
    var emojis: [Character] {
        return filter{ $0.isEmoji }
    }
    
    /// 表情：所有的表情
    var emojiString: String {
        return emojis.map{String($0) }.reduce("",+)
    }
    
    /// 表情：所有表情的单元标量
    var emojiScalars: [UnicodeScalar] {
        return filter{ $0.isEmoji }.flatMap{ $0.unicodeScalars }
    }
    
    /// 表情：所有非表情的字符
    var nonEmojis: [Character] {
        return filter{ !$0.isEmoji }
    }
    
    /// 表情：移除后的字符串
    var removeEmoji: String {
        return nonEmojis.map{ String($0) }.reduce("", +)
    }
}
