//
//  MessageCell.swift
//  Chat
//
//  Created by Владислав on 01.03.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: UITableViewCell, ConfigurableView {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    var message: Message?
    
    var userId = "vgrokhotov"
    var userName = "Vlad Grokhotov"

    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        messageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    typealias ConfigurationModel = Message
    
    func configure(with model: Message) {
        
        message = model
        
        messageLabel.text = model.content
        
        
        if (model.senderID != userId){
            messageView.backgroundColor = #colorLiteral(red: 0.8470765352, green: 0.8470765352, blue: 0.8470765352, alpha: 1)

            
            NSLayoutConstraint.deactivate([rightConstraint])
            NSLayoutConstraint.activate([leftConstraint])
            
        } else{
            messageView.backgroundColor = #colorLiteral(red: 0.3076745272, green: 0.5609909296, blue: 0.9542145133, alpha: 1)
            
            NSLayoutConstraint.deactivate([leftConstraint])
            NSLayoutConstraint.activate([rightConstraint])
        }
        
        senderName.text = model.senderName
        
        let date = model.created
        
        let today = Date() // сегодня
        let calendar = Calendar.current
            
        let date0 = Calendar.current.startOfDay(for: today)//now 00:00
        let dateFormatterPrint = DateFormatter()

        if (calendar.compare(date0, to: date, toGranularity: .day) == .orderedDescending){
            if (calendar.compare(date0, to: date, toGranularity: .year) == .orderedDescending){
                dateFormatterPrint.dateFormat = "dd MMM, yyyy"
            } else{
                dateFormatterPrint.dateFormat = "dd MMM"
            }
        } else{
            dateFormatterPrint.dateFormat = "HH:mm"
        }
        
        dateLabel.text = dateFormatterPrint.string(from: date)
        
        
    }
}

struct Message {
    let content: String
    let created: Date
    let senderID: String
    let senderName: String
    let channelIdentifier: String
}

extension Message {
    var toDict: [String: Any] {
        return ["content": content,
                "created": Timestamp(date: created),
                "senderID": senderID,
                "senderName": senderName]
    }
}
