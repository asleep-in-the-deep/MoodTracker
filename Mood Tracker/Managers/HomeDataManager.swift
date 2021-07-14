//
//  HomeDataManager.swift
//  Mood Tracker
//
//  Created by Arina on 12.07.2021.
//

import UIKit
import Firebase

extension HomeViewController {
    
    func getRecords() {
        database.collection("records").getDocuments { querySnapshot, error in
            if let error = error {
                let errorAlert = UIAlertController(title: "Loading error", message: error.localizedDescription, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                
                self.present(errorAlert, animated: true, completion: nil)
                
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()

                    let timestamp = data["date"] as? Timestamp
                    let date = timestamp?.dateValue()

                    let record = Record(date: date ?? Date(),
                                        mood: data["mood"] as! Int,
                                        energy: data["energy"] as! Int,
                                        anxiety: data["anxiety"] as! Int,
                                        annoyance: data["annoyance"] as! Int,
                                        selfEsteem: data["selfEsteem"] as! Int,
                                        sleepTime: data["sleepTime"] as! String)

                    self.records.append(record)
                }
                self.records = self.records.sorted(by: { $0.date > $1.date })
                self.observer = "done"
            }
        }
    }
    
    func sumWeekMood() -> String? {
        let todayDate = Date()
        
        let calendar = Calendar.current
        let weekBeforeDate = calendar.date(byAdding: .weekOfYear, value: -1, to: Date())!
        
        let range = weekBeforeDate...todayDate
        
        var moods: [Double] = []
        for record in records {
            if range.contains(record.date) {
                moods.append(Double(record.mood))
            }
        }
        
        var sumMoods: Double = 0
        for mood in moods {
            sumMoods += mood
        }
        
        return String(format: "%.1f", sumMoods / Double(moods.count))
    }

    
}
