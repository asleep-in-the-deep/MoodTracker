//
//  RecordViewCell.swift
//  Mood Tracker
//
//  Created by Arina on 11.07.2021.
//

import UIKit

class RecordViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moodEmoji: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var sleepTimeLabel: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
    
    @IBOutlet weak var selfEsteemLabel: UILabel!
    @IBOutlet weak var anxietyLabel: UILabel!
    @IBOutlet weak var annoyanceLabel: UILabel!
    
    func decorateCell() {
        layer.cornerRadius = 15
        layer.borderColor = UIColor.separator.cgColor
        layer.borderWidth = 1
    }
    
    func setMoodEmoji(for mood: Int) -> String {
        switch mood {
        case 0:
            self.moodLabel.textColor = .systemBlue
            return "😭"
        case 1:
            self.moodLabel.textColor = .systemPurple
            return "😔"
        case 2:
            return "😕"
        case 3:
            return "😐"
        case 4:
            return "🙂"
        case 5:
            self.moodLabel.textColor = .systemOrange
            return "😄"
        case 6:
            self.moodLabel.textColor = .systemRed
            return "🤩"
        default:
            return "😐"
        }
    }
    
    func setSelfEsteemLabel(for selfEsteem: Int) -> String {
        switch selfEsteem {
        case 4:
            self.selfEsteemLabel.textColor = .systemRed
            return "😍 \(selfEsteem)"
        default:
            return "🥰 \(selfEsteem)"
        }
    }
    
    func setAnxietyLabel(for anxiety: Int) -> String {
        switch anxiety {
        case 3:
            self.anxietyLabel.textColor = .systemRed
            return "😰 \(anxiety)"
        default:
            return "😥 \(anxiety)"
        }
    }
    
    func setAnnoyanceLabel(for annoyance: Int) -> String {
        switch annoyance {
        case 3:
            self.annoyanceLabel.textColor = .systemRed
            return "😡 \(annoyance)"
        default:
            return "😠 \(annoyance)"
        }
    }
}
