//
//  NewRecordViewController.swift
//  Mood Tracker
//
//  Created by Arina on 11.07.2021.
//

import UIKit
import Firebase
import HealthKit

class NewRecordViewController: UIViewController {
    
    let database = Firestore.firestore()
    
    let dateManager = DateManager()
    
    var currentRecord: Record!
    var addedRecords: [Record] = []
    
    var sleepDuration: Int = 0
    
    var sublayer = UIView()
    let activityIndicator = UIActivityIndicatorView()
    
    var observer: String = "" {
        didSet {
            if observer != "" {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.sublayer.removeFromSuperview()
                }
                
            }
        }
    }
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var moodSegmetedControl: UISegmentedControl!
    @IBOutlet weak var annoyanceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var anxietySegmentedControl: UISegmentedControl!
    @IBOutlet weak var energySegmentedControl: UISegmentedControl!
    @IBOutlet weak var selfEsteemSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var sleepTimeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLoadingView()
        
        setScreen()
        setSleepCountDown()
        
        if currentRecord == nil {
            readSleep()
        } else {
            observer = "done"
        }
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        checkingBeforeSaving()
    }
    
    func setScreen() {
        if currentRecord != nil {
            dateLabel.text = dateManager.dateToString(date: currentRecord.date)
            
            moodSegmetedControl.selectedSegmentIndex = currentRecord.mood
            annoyanceSegmentedControl.selectedSegmentIndex = currentRecord.annoyance
            anxietySegmentedControl.selectedSegmentIndex = currentRecord.anxiety
            energySegmentedControl.selectedSegmentIndex = currentRecord.energy
            selfEsteemSegmentedControl.selectedSegmentIndex = currentRecord.selfEsteem
            
            sleepTimeTextField.text = currentRecord.sleepTime
        } else {
            dateLabel.text = dateManager.dateToString(date: Date())
        }
    }
    
    func setSleepTime() {
        let hours = sleepDuration / (60 * 60)
        let minutes = sleepDuration % (60 * 60) / 60
        
        DispatchQueue.main.async { [self] in
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
    }
    
    func setLoadingView() {
        sublayer = UIView(frame: self.view.bounds)
        sublayer.backgroundColor = UIColor(named: "Background")
        view.addSubview(sublayer)
        
        activityIndicator.style = .large
        activityIndicator.center = sublayer.center
        sublayer.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

}

extension NewRecordViewController {
    
    func readSleep() {
        let healthStore = HKHealthStore()
        var sleepDuration: Int = 0
        
        if let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 10, sortDescriptors: [sortDescriptor]) { query, result, error in
                if error != nil {
                    print(error?.localizedDescription)
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
