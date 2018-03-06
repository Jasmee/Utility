//
//  DatesViewController.swift
//  Utility
//
//  Created by Jasmee Sengupta on 02/03/18.
//  Copyright © 2018 Jasmee Sengupta. All rights reserved.
//

import Foundation
import UIKit

class DatesViewController: UIViewController {
    
    var pastDate: Date? {
        guard let date = Date.getDateFromString(date: "01/01/1980") else { return nil }
        return date
    }
    
    var futureDate: Date? {
        guard let date = Date.getDateFromString(date: "01/01/2020") else { return nil }
        return date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()/*
        differenceInDates(from: pastDate, to: futureDate)
        //differenceInDates(from: futureDate, to: pastDate) // future to past returns negative value
        print(offset(from: pastDate, to: futureDate))
        //print(pastDate?.offset(from: futureDate!)) // returns ""
        print("\nToday and now")
        print(Date.today())
        print(Date.now())
        print("\ndifferentFormatsOfNow")
        differentFormatsOfNow()*/
        //differentStylesofNow()
    }

    // compute difference between two Dates in year, moth, week, day, hour, minute, second
    func differenceInDates(from: Date?, to: Date?) {
        guard let fromDate = from, let toDate = to else { return }
        let years = toDate.yearsElapsed(from: fromDate)
        print("Differnce in years : \(years)")
        let months = toDate.monthsElapsed(from: fromDate)
        print("Differnce in months : \(months)")
        let weeks = toDate.weeksElapsed(from: fromDate)
        print("Differnce in weeks : \(weeks)")
        let days = toDate.daysElapsed(from: fromDate)
        print("Differnce in days : \(days)")
        let hours = toDate.hoursElapsed(from: fromDate)
        print("Differnce in hours : \(hours)")
        let minutes = toDate.minutesElapsed(from: fromDate)
        print("Differnce in minutes : \(minutes)")
        let seconds = toDate.secondsElapsed(from: fromDate)
        print("Differnce in seconds : \(seconds)")
    }
    
    func offset(from: Date?, to: Date?) -> String {
        guard let fromDate = from, let toDate = to else { return "wrong order"}
        let offset = toDate.offset(from: fromDate)
        return offset
    }
    
    func differentFormatsOfNow() {
        let now = Date()
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/mm/yyyy" // 02/19/2018 wrong - mm is minutes
        //print(formatter.string(from: now))
        formatter.dateFormat = "dd/MMM/yyyy" // 02/03/2018
        print(formatter.string(from: now))
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss" // 02/03/2018 16:19:32
        print(formatter.string(from: now))
        formatter.dateFormat = "dd-MMM-yyyy" // 02-Mar-2018
        print(formatter.string(from: now))
        formatter.dateFormat = "yyyyMMddHHmmss" // 20180302161932
        print(formatter.string(from: now))
        formatter.dateFormat = "dd MMM yyyy" // 02 Mar 2018
        print(formatter.string(from: now))
        formatter.dateFormat = "EEEE, dd MMM yyyy" // Friday, 02 Mar 2018
        print(formatter.string(from: now))
        formatter.dateFormat = "yyyy-MM-dd" // 2018-03-02
        print(formatter.string(from: now))
        if let date = futureDate {
            formatter.dateFormat = "dd MMMM yyyy" // prints complete month name
            print(formatter.string(from: date))
        }
    }
    
    func differentStylesofNow() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        print("full: \(formatter.string(from: now))")
        formatter.dateStyle = .long
        print("long: \(formatter.string(from: now))")
        formatter.dateStyle = .medium
        print("medium: \(formatter.string(from: now))")
        formatter.dateStyle = .short
        print("short: \(formatter.string(from: now))")
        formatter.dateStyle = .none
        print("none: \(formatter.string(from: now))")
    }

}


extension Date {
    static func getDateFromString(date dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yyyy"
        guard let date = formatter.date(from: dateString) else { return nil }
        return date
    }
    
    static func getDateFromString(date dateString: String, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        guard let date = formatter.date(from: dateString) else { return nil }
        return date
    }
    
    static func today() -> String {// var today possible?
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let todayString = formatter.string(from: today)
        return todayString
    }
    
    static func now() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let nowString = formatter.string(from: now)
        return nowString
    }
}

extension Date {// Get difference of two Dates in year, moth, week, day, hour, minute, second
    func yearsElapsed(from fromDate: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: fromDate, to: self).year ?? 0
    }
    
    func monthsElapsed(from fromDate: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: fromDate, to: self).month ?? 0
    }
    
    func weeksElapsed(from fromDate: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: fromDate, to: self).weekOfMonth ?? 0
    }
    
    func daysElapsed(from fromDate: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: fromDate, to: self).day ?? 0
    }
    
    func hoursElapsed(from fromDate: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: fromDate, to: self).hour ?? 0
    }
    
    func minutesElapsed(from fromDate: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: fromDate, to: self).minute ?? 0
    }
    
    func secondsElapsed(from fromDate: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: fromDate, to: self).second ?? 0
    }
    
    // just a function to say 40y lapsed on futureDate from pastDate. vice versa returns ""
    func offset(from date: Date) -> String {
        if yearsElapsed(from: date)   > 0 { return "\(yearsElapsed(from: date))y"   }
        if monthsElapsed(from: date)  > 0 { return "\(monthsElapsed(from: date))M"  }
        if weeksElapsed(from: date)   > 0 { return "\(weeksElapsed(from: date))w"   }
        if daysElapsed(from: date)    > 0 { return "\(daysElapsed(from: date))d"    }
        if hoursElapsed(from: date)   > 0 { return "\(hoursElapsed(from: date))h"   }
        if minutesElapsed(from: date) > 0 { return "\(minutesElapsed(from: date))m" }
        if secondsElapsed(from: date) > 0 { return "\(secondsElapsed(from: date))s" }
        return ""
    }
}
