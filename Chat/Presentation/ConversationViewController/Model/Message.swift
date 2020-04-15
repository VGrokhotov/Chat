//
//  Message.swift
//  Chat
//
//  Created by Владислав on 12.04.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation
import Firebase

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
