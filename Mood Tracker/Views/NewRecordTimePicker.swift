//
//  NewRecordDatePicker.swift
//  Mood Tracker
//
//  Created by Arina on 12.07.2021.
//

import UIKit

extension NewRecordViewController {
    
    func setSleepCountDown() {
        let screenWidth = UIScreen.main.bounds.width
        
        let timePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 220))
        timePicker.datePickerMode = .countDownTimer
        
        if #available(iOS 14, *) {
            timePicker.preferredDatePickerStyle = .wheels
            timePicker.sizeToFit()
        }
        
        sleepTimeTextField.inputView = timePicker
        timePicker.minuteInterval = 10

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(tapDone))
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        
        sleepTimeTextField.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.sleepTimeTextField.resignFirstResponder()
    }
    
    @objc func tapDone() {
        if let datePicker = self.sleepTimeTextField.inputView as? UIDatePicker {
            let sleepDuration = Int(datePicker.countDownDuration)
            let hours = sleepDuration / (60 * 60)
            let minutes = sleepDuration % (60 * 60) / 60
            
            if hours == 0 {
                sleepTimeTextField.text = "0:\(minutes)"
            } else {
                if minutes == 0 {
                    sleepTimeTextField.text = "\(hours):00"
                }
                else {
                    sleepTimeTextField.text = "\(hours):\(minutes)"
                }
            }
        }
        
        self.sleepTimeTextField.resignFirstResponder()
        self.saveButton.isEnabled = true
    }
}
