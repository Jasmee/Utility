//
//  LocalNotificationViewController.swift
//  Utility
//
//  Created by Jasmee Sengupta on 27/02/18.
//  Copyright © 2018 Jasmee Sengupta. All rights reserved.
//  All about Local Notifications
//  Mext task - isAuthorizedToNotify how to sync call, autolayout issues, button text display, not repeating notif, badge how to
/*
 Important classes:
 UserNotifications
 UNUserNotificationCenter
 UNAuthorizationOptions - 4 notification types, badge, sound, alert, carPlay
 UNNotificationSettings
 UNNotificationRequest - UNMutableNotificationContent and UNTimeIntervalNotificationTrigger -> schedule
 */

import Foundation
import UIKit
import UserNotifications//earlier to iOS 10, included in UIKit
import CoreLocation

class LocalNotificationViewController: UIViewController {
    
    //Constants: notification identifiers . enum required?
    let TIME_INTERVAL_NOTIFICATION = "TimeIntervalNotification"
    let CALENDAR_NOTIFICATION = "CalendarNotification"
    let LOCATION_NOTIFICATION = "LocationNotification"
    let FOREGROUND_NOTIFICATION = "ImmediateNotification"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthorization()
        registerCustomActionCategories()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // MARK: Authorization to notify
    
    //early in app life application:didFinishLaunchingWithOptions: - The first time your App requests authorization the system shows the user an alert, after that they can manage the permissions from settings
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge, .carPlay]// Q. message does not change on options requested?
        center.requestAuthorization(options: options, completionHandler: {(success, error) in
            if success {
                print("granted")
                //self.checkAuthorization()
                //<UNNotificationSettings: 0x60000009b3f0; authorizationStatus: Authorized, notificationCenterSetting: Enabled, soundSetting: Enabled, badgeSetting: Enabled, lockScreenSetting: Enabled, carPlaySetting: NotSupported, alertSetting: Enabled, alertStyle: Banner>
                self.isAuthorizedToNotify()
            }else {
                print("error granting notifiction authorization \(error.debugDescription)")
            }
        })
    }
    
    func isAuthorizedToNotify() -> Bool{// how to call in sync
        let isAuthorized = false
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(completionHandler: {settings in
            print(settings.authorizationStatus.rawValue)
            print(settings.alertSetting.rawValue)
            print(settings.badgeSetting.rawValue)
            print(settings.soundSetting.rawValue)
            print(settings.showPreviewsSetting)
            print(settings.lockScreenSetting)
            print(settings.notificationCenterSetting)
            print(settings.carPlaySetting)
        })
        return isAuthorized//this will always return false
    }
    
    // MARK: IBActions
    
    @IBAction func notifyInFiveSeconds(_ sender: UIButton) {
        // press cmd+shift+H or home button to take the app to background
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
            if settings.authorizationStatus == .authorized {// what about other 5 status
                self.triggerTimeIntervalNotification(notification: self.configNotificationContent(body: "Notified in 5 seconds"))
            } else {
                print("This app is not authorized to deliver notifications")
            }
        })
    }
    
    @IBAction func notifyOnADate(_ sender: UIButton) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
            if settings.authorizationStatus == .authorized {
                self.triggerCalendarNotification(notification: self.configNotificationContent(body: "Notified on certain date"))
            } else {
                print("This app is not authorized to deliver notifications")
            }
        })
    }
    
    @IBAction func notifyOnLocation(_ sender: UIButton) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
            if settings.authorizationStatus == .authorized {
                self.triggerLocationNotification(notification: self.configNotificationContent(body: "Notified on reaching location"))
            } else {
                print("This app is not authorized to deliver notifications")
            }
        })
    }
    
    @IBAction func notifyWhenInForeground(_ sender: UIButton) {// needs willpresent delegate method
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
            if settings.authorizationStatus == .authorized {
                self.triggerForegroundNotification(notification: self.configNotificationContent(body: "Notified in foreground"))
            } else {
                print("This app is not authorized to deliver notifications")
            }
        })
    }
    
    // MARK: Notification content and trigger
    
    func configNotificationContent(body: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Subtitle"
        content.body = body
        content.sound = UNNotificationSound.default()
        content.badge = 1// more on this
        // How and when to use all these below
        //notification.categoryIdentifier =
        //notification.attachments =
        //notification.launchImageName =
        //notification.userInfo =
        return content
    }
    
    func triggerTimeIntervalNotification(notification: UNMutableNotificationContent) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)// at least 60 sec for repeat = true
        let request = UNNotificationRequest(identifier: TIME_INTERVAL_NOTIFICATION, content: notification, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            if let error = error {
                print("Could not trigger time interval notification, error: \(error)")
            }
        })
    }
    
    func triggerCalendarNotification(notification: UNMutableNotificationContent) {
        let date = Date(timeIntervalSinceNow: 10)
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)// not repeating
        let request = UNNotificationRequest(identifier: CALENDAR_NOTIFICATION, content: notification, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to trigger notification on specified date \(error)")
            }
        }
    }
    
    // Test whether actually works
    func triggerLocationNotification(notification: UNMutableNotificationContent) {
        //import CoreLocation to get CLRegion initializer
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 13, longitude: 77) , radius: 20, identifier: "MonitoredRegion")
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        let request = UNNotificationRequest(identifier: LOCATION_NOTIFICATION, content: notification, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            if let error = error {
                print("Could not trigger location notification, \(error)")
            } else {
                print("Location notification added.")
            }
        })
    }
}

extension LocalNotificationViewController: UNUserNotificationCenterDelegate {
    
    // UNUserNotificationCenterDelegate - willPresent required, to deliver when in foreground
    func triggerForegroundNotification(notification: UNMutableNotificationContent) {// App in foreground
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: FOREGROUND_NOTIFICATION, content: notification, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            if let error = error {
                print("Could not trigger time interval notification, \(error)")
            }
        })
    }
    
    // needs delegate only to perform action when user selects a button, not for presenting.
    // drag down the notification to reveal action buttons
    @IBAction func notifyWithCustomeActions(_ sender: UIButton) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
            if settings.authorizationStatus == .authorized {
                self.notificationWithCustomAction()
            } else {
                print("This app is not authorized to deliver notifications")
            }
        })
    }
    
    func notificationWithCustomAction() {
        let content = UNMutableNotificationContent()
        content.title = "Let's start"
        content.subtitle = "For the destiny, custom actions below"
        content.body = "You have to go out in 10 minutes from now"
        content.sound = UNNotificationSound.default()
        //content.categoryIdentifier = "SnoozeOrDelete"
        content.categoryIdentifier = "FourActions"
        triggerForegroundNotification(notification: content)
        //triggerTimeIntervalNotification(notification: content)// this works in foreground now
    }
    
    func registerCustomActionCategories() {// register categories early in app lifecycle
        let snoozeAction = UNNotificationAction(identifier: "snoozeAction", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "deleteAction", title: "Delete", options: [.destructive])
        let okAction = UNNotificationAction(identifier: "okAction", title: "OK", options: [])
        let thinkAction = UNNotificationAction(identifier: "thinkAction", title: "Think", options: [])
        
        let snoozeOrDeleteCategory = UNNotificationCategory(identifier: "SnoozeOrDelete", actions: [snoozeAction, deleteAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "Preview placeholder", options: [])
        let foregroundCategory = UNNotificationCategory(identifier: "FourActions", actions: [okAction, snoozeAction, thinkAction, deleteAction], intentIdentifiers: [], options: [])
        
        //I am able to add more than four actions and also able to repeat them
        //let extraAction = UNNotificationAction(identifier: "extraAction", title: "Extra", options: [])
        //let foregroundCategory = UNNotificationCategory(identifier: "FourActions", actions: [okAction, snoozeAction, thinkAction, extraAction, extraAction, deleteAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([snoozeOrDeleteCategory, foregroundCategory])
        // check what you have got
//        UNUserNotificationCenter.current().getNotificationCategories(completionHandler: {categories in
//            print(categories)
//        })
    }
    
    // MARK: UserNotification delegates
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Omit this method or omit the completion handler to ignore notification when in foreground
        completionHandler([.alert, .badge, .sound])//deliver notification when app is in foreground, completionHandler required - why? how does this work?
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //custom actions are handled here
        print(response)
        switch response.actionIdentifier {
        case "snoozeAction":
            print("User chose to snooze")
        case "deleteAction":
            print("User chose to delete")
        default:
            print("default")// ok. think not handled
        }
        completionHandler()// why call this? else warning at runtime debug log.
    }
    
    // test these two methods. Use case?
    
    func pendingNotification() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (pendingRequests) in
            print(pendingRequests.count)
            //center.removeAllPendingNotificationRequests() //OR remove by id
            center.removePendingNotificationRequests(withIdentifiers: [self.CALENDAR_NOTIFICATION, self.LOCATION_NOTIFICATION])
        }
    }
    
    func deliveredNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getDeliveredNotifications { (deliveredNotifications) in
            print(deliveredNotifications.count)
            //deliveredNotifications[0].date, deliveredNotifications[0].request // when to use
            //center.removeAllDeliveredNotifications() //OR remove by id
            center.removeDeliveredNotifications(withIdentifiers: [self.FOREGROUND_NOTIFICATION, self.TIME_INTERVAL_NOTIFICATION])
        }
    }
    
}
