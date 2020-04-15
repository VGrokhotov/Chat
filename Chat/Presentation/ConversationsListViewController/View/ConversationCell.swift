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
    @IBOutlet weak var dateLabel: UILabel!
    
    var channel: Channel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ConversationCell: ConfigurableView{
    typealias ConfigurationModel = Channel
    
    func configure(with model: Channel){
        
        channel = model
        
        nameLabel.text = model.name
        
        if let lastActivity = model.lastActivity {
            if Date().timeIntervalSince(lastActivity) < 600.0{
                self.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 0.9012467894, alpha: 1)
            } else{
                self.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        } else{
            self.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        
        messageLabel.text = model.lastMessage
        messageLabel.font = UIFont.systemFont(ofSize: 17)
        
        
        if let date = model.lastActivity{
            
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
        } else {
            dateLabel.text = nil
        }
        
    }
    
    
}

protocol ConfigurableView {
    
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}
