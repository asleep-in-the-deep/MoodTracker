//
//  SleepManager.swift
//  Mood Tracker
//
//  Created by Arina on 11.08.2021.
//

import UIKit
import HealthKit

extension NewRecordViewController {
    
    func readSleep() {
        let healthStore = HKHealthStore()
        var sleepDuration: Int = 0
        
        if let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 10, sortDescriptors: [sortDescriptor]) { query, result, error in
                if error != nil {
                    self.showAlert(title: "Sleep data error", message: "Please enter sleep duration manually")
                }
                if let result = result {
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                            if value == "Asleep" {
                                let calendar = Calendar.current
                                let dayBefore = calendar.date(byAdding: .day, value: -1, to: Date())!
                                let range = dayBefore...Date()
                                
                                if range.contains(sample.startDate) {
                                    let timeInterval = Int(
                                        (sample.endDate).timeIntervalSince(sample.startDate))
                                    sleepDuration += timeInterval
                                    self.sleepDuration = sleepDuration
                                }
                            }
                        }
                    }
                    self.setSleepTime()
                    self.observer = "done"
                }
            }
            healthStore.execute(query)
        }
    }
}
