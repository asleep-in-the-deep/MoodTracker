//
//  HomeCollectionView.swift
//  Mood Tracker
//
//  Created by Arina on 12.07.2021.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return records.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recordCell", for: indexPath) as! RecordViewCell
        
        let record = records[indexPath.item]
                
        cell.moodEmoji.text = cell.setMoodEmoji(for: record.mood)
        cell.moodLabel.text = String(record.mood)
        
        cell.dateLabel.text = dateManager.dateToString(date: record.date)

        cell.sleepTimeLabel.text = "🌙 \(record.sleepTime)"
        cell.energyLabel.text = "⚡️ \(record.energy)"

        cell.selfEsteemLabel.text = cell.setSelfEsteemLabel(for: record.selfEsteem)
        cell.annoyanceLabel.text = cell.setAnnoyanceLabel(for: record.annoyance)
        cell.anxietyLabel.text = cell.setAnxietyLabel(for: record.anxiety)
        
        cell.decorateCell()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        choosedRecord = records[indexPath.item]
        performSegue(withIdentifier: "showDay", sender: self)
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 40, height: 140)
    }
    
}
