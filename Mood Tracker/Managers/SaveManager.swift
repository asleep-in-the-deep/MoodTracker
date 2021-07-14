//
//  SaveManager.swift
//  Mood Tracker
//
//  Created by Arina on 12.07.2021.
//

import UIKit
import Firebase

extension NewRecordViewController {
    
    func saveRecord() {
        if currentRecord == nil {
            var reference: DocumentReference? = nil
            reference = database.collection("records").addDocument(data: [
                "date": dateManager.getCurrentDate() ?? Date(),
                "mood": moodSegmetedControl.selectedSegmentIndex,
                "annoyance": annoyanceSegmentedControl.selectedSegmentIndex,
                "anxiety": anxietySegmentedControl.selectedSegmentIndex,
                "energy": energySegmentedControl.selectedSegmentIndex,
                "selfEsteem": selfEsteemSegmentedControl.selectedSegmentIndex,
                "sleepTime": sleepTimeTextField.text ?? "0:00"
            ]) { error in
                if let error = error {
                    let errorAlert = UIAlertController(title: "Saving error", message: error.localizedDescription, preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    
                    self.present(errorAlert, animated: true, completion: nil)
                    
                } else {
                    self.performSegue(withIdentifier: "backToHome", sender: self)
                }
            }
        }
    }
    
    func checkingBeforeSaving() {
        var dayStatus: String?
                
        print(addedRecords)
        for record in addedRecords {
            if record.date == dateManager.getCurrentDate() {
                dayStatus = "completed"
                print("completed")
            }
        }
                
        if dayStatus == "completed" {
            self.saveButton.isEnabled = false
            
            let saveAlert = UIAlertController(title: "Saving error", message: "You have already added a record for today", preferredStyle: .alert)
            saveAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
            self.present(saveAlert, animated: true, completion: nil)
            print("alert")
        } else {
            saveRecord()
        }
    }
}
