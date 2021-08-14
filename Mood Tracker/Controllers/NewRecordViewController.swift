//
//  NewRecordViewController.swift
//  Mood Tracker
//
//  Created by Arina on 11.07.2021.
//

import UIKit
import Firebase

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
        
    @IBOutlet weak var datePicker: UIDatePicker!
    
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
            datePicker.date = currentRecord.date
            
            moodSegmetedControl.selectedSegmentIndex = currentRecord.mood
            annoyanceSegmentedControl.selectedSegmentIndex = currentRecord.annoyance
            anxietySegmentedControl.selectedSegmentIndex = currentRecord.anxiety
            energySegmentedControl.selectedSegmentIndex = currentRecord.energy
            selfEsteemSegmentedControl.selectedSegmentIndex = currentRecord.selfEsteem
            
            sleepTimeTextField.text = currentRecord.sleepTime
        } else {
            datePicker.date = Date()
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
    
    func showAlert(title: String, message: String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }

}


