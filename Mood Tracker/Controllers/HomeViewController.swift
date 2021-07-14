//
//  HomeViewController.swift
//  Mood Tracker
//
//  Created by Arina on 11.07.2021.
//

import UIKit
import FSCalendar
import Firebase

class HomeViewController: UIViewController {
    
    let database = Firestore.firestore()
    
    let dateManager = DateManager()
    
    var records: [Record] = []
    var choosedRecord: Record?
    
    weak var calendar: FSCalendar!
    var weekView: UIView!
    var dayView: UIView!
    
    var screenMode: String = "cards"

    @IBOutlet weak var changeModeButton: UIBarButtonItem!
    @IBOutlet weak var recordsCollectionView: UICollectionView!
    
    var sublayer = UIView()
    let activityIndicator = UIActivityIndicatorView()
    
    var observer: String = "" {
        didSet {
            if observer != "" {
                recordsCollectionView.reloadData()
                calendar.reloadData()
                activityIndicator.stopAnimating()
                sublayer.removeFromSuperview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLoadingView()
        getRecords()
        
        createCalendar()
    }
    
    @IBAction func changeModeTapped(_ sender: Any) {
        if screenMode == "cards" {
            self.screenMode = "calendar"
            changeModeButton.image = UIImage(systemName: "book")
            
            recordsCollectionView.isHidden = true
            
            calendar.isHidden = false
            setWeekView()
            weekView.isHidden = false
            
        } else if screenMode == "calendar" {
            self.screenMode = "cards"
            changeModeButton.image = UIImage(systemName: "calendar")
            
            recordsCollectionView.isHidden = false
            calendar.isHidden = true
            weekView.isHidden = true
            if dayView != nil {
                dayView.isHidden = true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDay" {
            if let destinationNavigation = segue.destination as? UINavigationController {
                if let targetController = destinationNavigation.topViewController as? NewRecordViewController {
                    targetController.currentRecord = choosedRecord
                }
            }
        } else if segue.identifier == "addDay" {
            if let destinationNavigation = segue.destination as? UINavigationController {
                if let targetController = destinationNavigation.topViewController as? NewRecordViewController {
                    targetController.addedRecords = records
                }
            }
        } else if segue.identifier == "showChart" {
            if let destinationNavigation = segue.destination as? UINavigationController {
                if let targetController = destinationNavigation.topViewController as? ChartViewController {
                    targetController.records = records
                }
            }
        }
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.records = []
                self.getRecords()
                
                self.recordsCollectionView.reloadData()
                self.calendar.reloadData()
            }
        }
    }
    
}




