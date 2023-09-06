//
//  TimeTableViewCell.swift
//  STYLiSH
//
//  Created by 李童 on 2023/9/6.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    
    var countdownTimer: Timer?
    var secondsRemaining = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func updateTimer() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
            updateCountdownLabel()
        } else {
            countdownTimer?.invalidate()
            createNotificationContent()
        }
    }
    
    func updateCountdownLabel() {
        let hours = secondsRemaining / 60 / 60
        let minutes = secondsRemaining / 60 % 60
        let seconds = secondsRemaining % 60
        timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func createNotificationContent() {
        let content = UNMutableNotificationContent()
        content.title = "STYLiSH"
        content.subtitle = "競拍賣結束囉"
        content.body = "競拍結束囉，來看看自己得標了沒"
//        content.badge = 1
        content.sound = UNNotificationSound.defaultCritical
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.2, repeats: false)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

}
