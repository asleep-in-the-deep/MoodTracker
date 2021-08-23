//
//  DateManager.swift
//  Mood Tracker
//
//  Created by Arina on 12.07.2021.
//

import Foundation

class DateManager {
        
    func getCurrentDate(date: Date = Date()) -> Date? {
        let calendar = Calendar.current
        
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return calendar.date(from: components)
    }
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy"
        formatter.locale = Locale(identifier: "en_GB")
        let resultDate = formatter.string(from: date)
        return resultDate
    }
}
