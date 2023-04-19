
import Foundation

private extension Date {
    
    /// 日历。
    /// 注：在此处方便统一使用。方便后续进行日期国际化后统一修改。
    static var calendar: Calendar {
        return Calendar.current
    }
}

//MARK: --- 日期和字符串的相互转换
public extension Date {

    /// 字符串转换为Date
    init(_ dateString: String, dateFormat: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        self = dateFormatter.date(from: dateString)!
    }
    
    /// 日期转化为字符串
    func formatToString(_ dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
}

//MARK: --- 日期分解
public extension Date {
    
    // 年
    var year: Int {
        let calendar = Date.calendar
        return calendar.component(.year, from: self)
    }
    
    // 月
    var month: Int {
        let calendar = Date.calendar
        return calendar.component(.month, from: self)
    }
    
    // 日
    var day: Int {
        let calendar = Date.calendar
        return calendar.component(.day, from: self)
    }
    
    // 小时
    var hour: Int {
        let calendar = Date.calendar
        return calendar.component(.hour, from: self)
    }
    
    // 分钟
    var minute: Int {
        let calendar = Date.calendar
        return calendar.component(.minute, from: self)
    }
    
    // 秒
    var second: Int {
        let calendar = Date.calendar
        return calendar.component(.second, from: self)
    }
    
    // 周
    var weekday: Int {
        let calendar = Date.calendar
        return calendar.component(.weekday, from: self)
    }
}

//MARK: --- 日期转换
public extension Date {
    
    // 一天的开始
    var todayStart: Date {
        let calendar = Date.calendar
        let dateComponents = calendar.dateComponents([.year,.month,.day], from: self)
        let date = calendar.date(from: dateComponents)
        return date!
    }
    
    // 一天的结束
    var todayEnd: Date {
        let calendar = Date.calendar
        var dateComponents = calendar.dateComponents([.year,.month,.day], from: self)
        dateComponents.hour = 23
        dateComponents.minute = 59
        dateComponents.second = 59
        let date = calendar.date(from: dateComponents)
        return date!
    }
    
    // 一月的开始
    var monthStart: Date {
        let calendar = Date.calendar
        let dateComponents = calendar.dateComponents([.year,.month], from: self)
        let date = calendar.date(from: dateComponents)
        return date!
    }
    
    // 一月的结束
    var monthEnd: Date {
        let calendar = Date.calendar
        var dateComponents = calendar.dateComponents([.year,.month,], from: self)
        dateComponents.month = dateComponents.month! + 1
        let date = calendar.date(from: dateComponents)!
        return date - 1
    }
    
    // 一年的开始
    var yearStart: Date {
        let calendar = Date.calendar
        let dateComponents = calendar.dateComponents([.year], from: self)
        let date = calendar.date(from: dateComponents)
        return date!
    }
    
    // 一年的结束
    var yearEnd: Date {
        let calendar = Date.calendar
        var dateComponents = calendar.dateComponents([.year], from: self)
        dateComponents.year = dateComponents.year! + 1
        let date = calendar.date(from: dateComponents)!
        return date - 1
    }
}

//MARK: --- 日期追加
public extension Date {
    
    // 追加`秒`
    func append(second: TimeInterval) -> Date {
        return self + second
    }
    
    // 追加`分`
    func append(minute: Int) -> Date {
        return append(second: TimeInterval(minute * 60))
    }
    
    // 追加`时`
    func append(hour: Int) -> Date {
        return append(minute: hour * 60)
    }
    
    // 追加`天`
    func append(day: Int) -> Date {
        return append(hour: day * 24)
    }
    
    // 追加`月`（注：如果 N 月之后超出了限制，则为最后一天的日期）
    func append(month: Int) -> Date {
        let calendar = Date.calendar
        var comps = DateComponents()
        comps.month = month
        return calendar.date(byAdding: comps, to: self)!
    }
    
    // 追加`年`
    func append(year: Int) -> Date {
        let calendar = Date.calendar
        var comps = DateComponents()
        comps.year = year
        return calendar.date(byAdding: comps, to: self)!
    }
}

//MARK: --- 日期比较
public extension Date {
    
    // 是否同一天
    func isSameDay(_ date: Date) -> Bool {
        let calendar = Date.calendar
        let comps1 = calendar.dateComponents([.year, .month, .day], from: self)
        let comps2 = calendar.dateComponents([.year, .month, .day], from: date)
        return comps1.year == comps2.year && comps1.month == comps2.month && comps1.day == comps2.day
    }
    
    // 是否同一个月
    func isSameMonth(_ date: Date) -> Bool {
        let calendar = Date.calendar
        let comps1 = calendar.dateComponents([.year, .month,], from: self)
        let comps2 = calendar.dateComponents([.year, .month,], from: date)
        return comps1.year == comps2.year && comps1.month == comps2.month
    }
    
    // 是否同一年
    func isSameYear(_ date: Date) -> Bool {
        return self.year == date.year
    }
}
