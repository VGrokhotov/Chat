//
//  Channel.swift
//  Chat
//
//  Created by Владислав on 12.04.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation
import Firebase

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String
    let lastActivity: Date?
    let section: String
}

extension Channel {
    var toDict: [String: Any] {
        if let date = lastActivity {
            return ["name": name,
                    "lastActivity": Timestamp(date: date)]
        }
        return ["name": name]
    }
}

extension Channel: Equatable {
    static func ==(lhs: Channel, rhs: Channel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
