//
//  Date+Extensions.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import Foundation

extension Date {
   static func createDateFromString(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+04:00")
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
   static func createStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        return dateFormatter.string(from: date)
    }
}
