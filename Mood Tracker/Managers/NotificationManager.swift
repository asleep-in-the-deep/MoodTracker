//
//  NotificationManager.swift
//  Mood Tracker
//
//  Created by Arina on 12.07.2021.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
        
    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if granted == true && error == nil {
                print("Notifications is working")
            }
        }
    }
    
    func scheduleNotifications(hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "How is your life today?"
        content.body = "Fill out today's questionnaire"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let uuidString = UUID().uuidString
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func removeNotifivations() {
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
    } 
}
