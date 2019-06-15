//
//  Extensions.swift
//  persianCalendar
//
//  Created by Farzaneh on 6/12/19.
//  Copyright © 2019 Farzaneh. All rights reserved.
//

import Foundation

//get first day of the month
extension Date {
    
    var persianCal: Calendar {
        var cal = Calendar(identifier: .persian)
        cal.locale = Locale(identifier: "fa_IR")
        return cal
    }
    var weekday: Int {
        return persianCal.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return  persianCal.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}

extension Date {
    func convertToPersianDate(formatString:String?="yyyy/MM/dd") -> String {
        let dateFormmater:DateFormatter = DateFormatter()
        dateFormmater.timeZone = TimeZone(abbreviation: "UTC")
        dateFormmater.calendar = Calendar(identifier: Calendar.Identifier.persian)
        dateFormmater.locale = Locale(identifier: "fa_IR")
        dateFormmater.dateFormat = formatString;
        return dateFormmater.string(from: self)
    }
}
