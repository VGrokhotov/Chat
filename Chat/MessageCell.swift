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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    typealias ConfigurationModel = MessageCellModel
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
    }
}

struct MessageCellModel{
    let text: String
}
