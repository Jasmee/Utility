//
//  LocalNotificationViewController.swift
//  Utility
//
//  Created by Jasmee Sengupta on 27/02/18.
//  Copyright © 2018 Jasmee Sengupta. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications//earlier to iOS 10, included in UIKit
import CoreLocation

class LocalNotificationViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    //Constants: notification identifiers . enum required?
    let TIME_INTERVAL_NOTIFICATION = "TimeIntervalNotification"
    let CALENDAR_NOTIFICATION = "CalendarNotification"
    let LOCATION_NOTIFICATION = "LocationNotification"
    let FOREGROUND_NOTIFICATION = "ImmediateNotification"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthorization()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // MARK: Authorization to notify
    
    //generally in appdelegate didfinishlaunchingwithoptions?
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
        triggerTimeIntervalNotification(notification: configNotificationContent())
    }
    
    @IBAction func notifyOnADate(_ sender: UIButton) {
        triggerCalendarNotification(notification: configNotificationContent())
    }
    
    @IBAction func notifyOnLocation(_ sender: UIButton) {
        triggerLocationNotification(notification: configNotificationContent())
    }
    
    @IBAction func notifyWhenInForeground(_ sender: UIButton) {
        triggerForegroundNotification(notification: configNotificationContent())
    }
    
    // MARK: Notification content and trigger
    
    func configNotificationContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Subtitle"
        content.body = "A good amount of text here"
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
    
    // MARK: UserNotification delegates
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])//deliver notification when app is in foreground, completionHandler - how does this work?
    }
}
