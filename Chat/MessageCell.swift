//
//  MessageCell.swift
//  Chat
//
//  Created by Владислав on 01.03.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, ConfigurableView {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    var leftConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var rightConstraint: NSLayoutConstraint = NSLayoutConstraint()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        leftConstraint = messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        rightConstraint = contentView.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: 10)
        
        messageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    typealias ConfigurationModel = MessageCellModel
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        
        if (model.type == .incoming){
            messageView.backgroundColor = #colorLiteral(red: 0.8470765352, green: 0.8470765352, blue: 0.8470765352, alpha: 1)

            
            NSLayoutConstraint.deactivate([rightConstraint])
            NSLayoutConstraint.activate([leftConstraint])
            
        } else{
            messageView.backgroundColor = #colorLiteral(red: 0.3076745272, green: 0.5609909296, blue: 0.9542145133, alpha: 1)
            
            NSLayoutConstraint.deactivate([leftConstraint])
            NSLayoutConstraint.activate([rightConstraint])
        }
    }
}

struct MessageCellModel{
    let text: String
    let type: TypeOfMessege
}

enum TypeOfMessege{
    case incoming
    case outgoing
}
