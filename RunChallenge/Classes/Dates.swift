//
//  Dates.swift
//  RunChallenge
//
//  Created by Moritz Haist on 10.07.21.
//

import Foundation

class Dates {
    
    let date = Date()
    let cal = Calendar(identifier: .gregorian)
    
    func getRemainingDays() -> Int {
        let monthRange = cal.range(of: .day, in: .month, for: date)!
        let daysInMonth = monthRange.count
        let remainingDays = daysInMonth - (date.get(.day))
        return remainingDays
    }
    
    func getYear() -> Int {
        return (date.get(.year))
    }
    
}

extension Date {
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("LLLL")
        return df.string(from: self)
    }
    
}
