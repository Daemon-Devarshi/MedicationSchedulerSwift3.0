//
//  NSDate+Utilities.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 9/2/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import Foundation

extension Date {
    //MARK: enum, constant declarations
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    
    func fullMinuteTime() -> Date {
        return self.getZeroSecondsTime()
    }
    
    func getZeroSecondsTime() -> Date {
        let cal = NSCalendar.current
        let fullMinute = (cal as NSCalendar).nextDate(after: self, matching: .second, value: 0,  options: [.matchNextTime, .searchBackwards])!
        return fullMinute
    }
    
    //MARK: Additional vars
    func displayTime() -> String {
        return Date.timeFormatter.string(from: self)
    }
}
