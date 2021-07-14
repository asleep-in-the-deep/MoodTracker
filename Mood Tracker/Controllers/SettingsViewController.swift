//
//  SettingsViewController.swift
//  Mood Tracker
//
//  Created by Arina on 11.07.2021.
//

import UIKit
import HealthKit

class SettingsViewController: UITableViewController {

    let defaults = UserDefaults.standard
    
    let notificationManager = NotificationManager()
    
    @IBOutlet weak var allowNotificationsSwitch: UISwitch!
    @IBOutlet weak var notificationTimePicker: UIDatePicker!
    @IBOutlet weak var accessToAHSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefaults()
    }
    
    @IBAction func allowNotificationsChanged(_ sender: Any) {
        if allowNotificationsSwitch.isOn {
            defaults.set(true, forKey: "allowNotifications")
            notificationManager.requestAutorization()
        } else {
            defaults.set(false, forKey: "allowNotifications")
            notificationManager.removeNotifivations()
        }
    }
    
    @IBAction func notificationTimeChoosed(_ sender: Any) {
        let date = notificationTimePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hours = components.hour!
        let minutes = components.minute!
        let timeString = "\(String(describing: hours)):\(String(describing: minutes))"
        
        defaults.set(timeString, forKey: "notificationTime")
        
        if defaults.bool(forKey: "allowNotifications") == true {
            notificationManager.removeNotifivations()
            notificationManager.scheduleNotifications(hour: hours, minute: minutes)
        }
    }
    
    @IBAction func accessToAHChanged(_ sender: Any) {
        if accessToAHSwitch.isOn {
            defaults.set(true, forKey: "accessToAppleHealth")
            getAccessToAppleHealth()
        } else {
            defaults.set(false, forKey: "accessToAppleHealth")
        }
    }
    
    func setDefaults() {
        let notificationStatus: Bool? = defaults.bool(forKey: "allowNotifications")
        let notificationTime: String? = defaults.string(forKey: "notificationTime")
        let appleHealthStatus: Bool? = defaults.bool(forKey: "accessToAppleHealth")
        
        if notificationStatus != nil {
            if notificationStatus == true {
                allowNotificationsSwitch.isOn = true
            } else {
                allowNotificationsSwitch.isOn = false
            }
        }
        
        if notificationTime != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "HH:mm"
            let date = dateFormatter.date(from: notificationTime!)
            notificationTimePicker.date = date!
        }
        
        if appleHealthStatus != nil {
            if appleHealthStatus == true {
                accessToAHSwitch.isOn = true
            } else {
                accessToAHSwitch.isOn = false
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsViewController {
    
    func getAccessToAppleHealth() {
        let healthStore = HKHealthStore()
        
        if let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            let setType = Set<HKSampleType>(arrayLiteral: sleepType)
            healthStore.requestAuthorization(toShare: nil, read: setType) { success, error in
                if !success || error != nil {
                    return
                }
            }
        }
    }
}
