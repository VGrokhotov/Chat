//
//  ConversationCell.swift
//  Chat
//
//  Created by Владислав on 29.02.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ConversationCell: ConfigurableView{
    typealias ConfigurationModel = ConversationCellModel
    
    func configure(with model: ConversationCellModel){
        
        nameLabel.text = model.name
        
        if model.isOnline{
            self.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 0.9012467894, alpha: 1)
        } else{
            self.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        if let message = model.message{
            messageLabel.text = message
            messageLabel.font = UIFont.systemFont(ofSize: 17)
        } else{
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 17)
        }
        
        
        if let date = model.date {
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
            dateLable.text = dateFormatterPrint.string(from: date)
        }
        
        if model.hasUnreadMessages{
            messageLabel.font = UIFont.boldSystemFont(ofSize: 18)
        }
        
    }
    
    
}


struct ConversationCellModel {
    
    let name: String
    let message: String?
    let date: Date?
    let isOnline: Bool
    let hasUnreadMessages: Bool
}

protocol ConfigurableView {
    
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}
