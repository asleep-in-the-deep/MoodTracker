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
            database.collection("records").addDocument(data: [
                "date": dateManager.getCurrentDate(date: datePicker.date) ?? Date(),
                "mood": moodSegmetedControl.selectedSegmentIndex,
                "annoyance": annoyanceSegmentedControl.selectedSegmentIndex,
                "anxiety": anxietySegmentedControl.selectedSegmentIndex,
                "energy": energySegmentedControl.selectedSegmentIndex,
                "selfEsteem": selfEsteemSegmentedControl.selectedSegmentIndex,
                "sleepTime": sleepTimeTextField.text ?? "0:00"
            ]) { error in
                if let error = error {
                    self.showAlert(title: "Saving error", message: error.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "backToHome", sender: self)
                }
            }
        } else {
            database.collection("records").getDocuments { querySnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let timestamp = data["date"] as? Timestamp
                        let date = timestamp?.dateValue()
                        
                        if date == self.currentRecord.date {
                            self.updateRecord(with: document.documentID)
                        }
                    }
                }
            }
        }
    }
    
    func updateRecord(with id: String) {
        let reference = database.collection("records").document(id)
        
        reference.updateData([
            "date": dateManager.getCurrentDate(date: datePicker.date) ?? Date(),
            "mood": moodSegmetedControl.selectedSegmentIndex,
            "annoyance": annoyanceSegmentedControl.selectedSegmentIndex,
            "anxiety": anxietySegmentedControl.selectedSegmentIndex,
            "energy": energySegmentedControl.selectedSegmentIndex,
            "selfEsteem": selfEsteemSegmentedControl.selectedSegmentIndex,
            "sleepTime": sleepTimeTextField.text ?? "0:00"
        ]) { error in
            if let error = error {
                self.showAlert(title: "Saving error", message: error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "backToHome", sender: self)
            }
        }
    }
    
    func checkingBeforeSaving() {
        var dayStatus: String?
                
        for record in addedRecords {
            if record.date == dateManager.getCurrentDate() {
                dayStatus = "completed"
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
