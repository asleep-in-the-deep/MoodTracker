//
//  HomeCalendar.swift
//  Mood Tracker
//
//  Created by Arina on 12.07.2021.
//

import UIKit
import FSCalendar

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func createCalendar() {
        let calendar = FSCalendar(frame: CGRect(x: 20, y: 120, width: UIScreen.main.bounds.width - 40, height: 400))
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
        
        self.calendar = calendar
        calendar.isHidden = true
        
        setCalendarAppearance()
    }
    
    func setCalendarAppearance() {
        calendar.appearance.headerTitleColor = .systemIndigo
        calendar.appearance.weekdayTextColor = .systemIndigo
        calendar.appearance.selectionColor = .systemOrange
        calendar.appearance.todayColor = .systemIndigo
        
        calendar.firstWeekday = 2
    }

    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        for record in records {
            if record.date == date {
                return String(record.mood)
            }
        }
        return nil
    }
    
    func setWeekView() {
        weekView = UIView(frame: CGRect(x: 20, y: 550, width: UIScreen.main.bounds.width - 40, height: 50))
        weekView = designView(view: weekView)
        weekView.isHidden = true
        view.addSubview(weekView)
        
        let sumLabel = UILabel(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width - 40, height: 50))
        sumLabel.text = "Average mood for the last week: \(sumWeekMood() ?? "no data")"
        weekView.addSubview(sumLabel)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        for record in records {
            if record.date == date {
                
                for view in view.subviews {
                    if view.tag == 100 {
                        view.removeFromSuperview()
                    }
                }
                
                dayView = UIView(frame: CGRect(x: 20, y: 620, width: UIScreen.main.bounds.width - 40, height: 80))
                dayView.tag = 100
                dayView = designView(view: dayView)
                dayView.isHidden = false
                view.addSubview(dayView)
                
                let dateLabel = UILabel(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width - 40, height: 50))
                dateLabel.text = "\(dateManager.dateToString(date: record.date)). Mood: \(record.mood)/6"
                
                let sleepLabel = UILabel(frame: CGRect(x: 20, y: 30, width: UIScreen.main.bounds.width - 40, height: 50))
                sleepLabel.text = "🌙 \(record.sleepTime) ⚡️\(record.energy) 😠 \(record.annoyance) 😥 \(record.anxiety) 🥰 \(record.selfEsteem)"
                
                dayView.addSubview(dateLabel)
                dayView.addSubview(sleepLabel)
                
                break
            } else {
                if dayView != nil {
                    dayView.isHidden = true
                }
            }
        }
    }
    
    func designView(view: UIView) -> UIView {
        let newView = view
        newView.backgroundColor = .white
        newView.layer.borderColor = UIColor.separator.cgColor
        newView.layer.borderWidth = 1
        newView.layer.cornerRadius = 15
        return newView
    }
    
}
