
import Foundation

// 字符与表情
public extension Character {
    
    // 是否为表情
    var isSimpleEmoji: Bool {
        guard let firstProperties = unicodeScalars.first?.properties else{ return false }
        if #available(iOS 10.2, *) {
            return unicodeScalars.count == 1 && (firstProperties.isEmojiPresentation || firstProperties.generalCategory == .otherSymbol)
        } else {
            return unicodeScalars.count == 1 && firstProperties.generalCategory == .otherSymbol
        }
    }
    
    // 是否为表情
    var isCombinedIntoEmoji: Bool {
        return unicodeScalars.count > 1 && unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector }
    }
    
    /// 是否为表情
    /// - Note: http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
    var isEmoji:Bool{
        return isSimpleEmoji || isCombinedIntoEmoji
    }
}
