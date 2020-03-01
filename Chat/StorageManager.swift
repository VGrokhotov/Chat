//
//  StorageManager.swift
//  Chat
//
//  Created by Владислав on 01.03.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import Foundation

class StorageManager{
    static func cells() -> [[ConversationCellModel]]{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        return      [[ConversationCellModel(name: "User 1", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2020/03/15 22:31")! , isOnline: true, hasUnreadMessages: false),
                      ConversationCellModel(name: "User 2", message: "gggggggggggg  gf g f gg fg f g f gf  fg gf ggg ff    fhfh", date: formatter.date(from: "2020/02/27 22:31")! , isOnline: true, hasUnreadMessages: false),
                      ConversationCellModel(name: "User 3", message: "ggg fd gg dg fhd hfh dh hfh dhf hhdfh hfh  fh dfggggggggggg ff    fhfh", date: formatter.date(from: "2018/10/08 22:31")! , isOnline: true, hasUnreadMessages: true),
                      ConversationCellModel(name: "User 4", message: nil, date: formatter.date(from: "2017/10/08 22:31")! , isOnline: true, hasUnreadMessages: false),
                      ConversationCellModel(name: "User 5", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2016/10/08 22:31")! , isOnline: true, hasUnreadMessages: false),
                      ConversationCellModel(name: "User 6", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2015/10/08 22:31")! , isOnline: true, hasUnreadMessages: false),
                      ConversationCellModel(name: "User 7", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2014/10/08 22:31")! , isOnline: true, hasUnreadMessages: true),
                      ConversationCellModel(name: "User 8", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2013/10/08 22:31")! , isOnline: true, hasUnreadMessages: true),
                      ConversationCellModel(name: "User 9", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2012/10/08 22:31")! , isOnline: true, hasUnreadMessages: false),
                      ConversationCellModel(name: "User 10", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2011/10/08 22:31")! , isOnline: true, hasUnreadMessages: true),
                    ],
                     [ConversationCellModel(name: "User 11", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2020/02/29 22:31")! , isOnline: false, hasUnreadMessages: false),
                      ConversationCellModel(name: "User 12", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2020/02/27 22:31")! , isOnline: false, hasUnreadMessages: true),
                      ConversationCellModel(name: "User 13", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2020/02/08 22:31")! , isOnline: false, hasUnreadMessages: false),
                      ConversationCellModel(name: "User 14", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2019/10/08 22:31")! , isOnline: false, hasUnreadMessages: false),
                      ConversationCellModel(name: "User 15", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2018/10/08 22:31")! , isOnline: false, hasUnreadMessages: false),
                      ConversationCellModel(name: "User 16", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2017/10/08 22:31")! , isOnline: false, hasUnreadMessages: false),
                      ConversationCellModel(name: "User 17", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2016/10/08 22:31")! , isOnline: false, hasUnreadMessages: true),
                      ConversationCellModel(name: "User 18", message: nil, date: formatter.date(from: "2015/10/08 22:31")! , isOnline: false, hasUnreadMessages: false),
                      ConversationCellModel(name: "User 19", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2014/10/08 22:31")! , isOnline: false, hasUnreadMessages: true),
                      ConversationCellModel(name: "User 20", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2013/10/08 22:31")! , isOnline: false, hasUnreadMessages: false),
                      ConversationCellModel(name: "User 21", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2012/10/08 22:31")! , isOnline: false, hasUnreadMessages: false),
                    ]]
        
    }
    
    static func messages() -> [MessageCellModel]{
        return [MessageCellModel(text: "how to laugh?", type: .incoming),
                MessageCellModel(text: "ahah hah haha ahah hahahah hahaha hha hahah hahahahah ha hah aha hahahah ahah hahahahahahahahahah a ahaha hah ah ah haah", type: .outgoing),
                MessageCellModel(text: "no ahah hah haha ahah hahahah hahaha hha hahah hahahahah ha hah aha hahahah ahah hahahahahahahahahah a ahaha hah ah ah haah", type: .incoming),
                MessageCellModel(text: "ahahaahahah ahahah ah ahahahha ahahaha hahah is right", type: .incoming),
                MessageCellModel(text: "oh, sry", type: .outgoing),
                MessageCellModel(text: "why do u think so?", type: .outgoing),
                MessageCellModel(text: "ahah", type: .incoming),
                MessageCellModel(text: "really?", type: .incoming),
                MessageCellModel(text: "ahahaha", type: .incoming),
                MessageCellModel(text: "ahahah", type: .incoming),
                MessageCellModel(text: "ahaha", type: .incoming),
                MessageCellModel(text: "ahahahahahaha", type: .incoming),
                MessageCellModel(text: "ahahahah ah hhaah aah ha", type: .incoming),
                MessageCellModel(text: "u really don't khow?", type: .incoming),
                MessageCellModel(text: "azzaazaaz", type: .incoming),
                MessageCellModel(text: "ahah", type: .incoming),
                MessageCellModel(text: "hahaah", type: .incoming),
                MessageCellModel(text: "_-_", type: .outgoing),
        ]
    }
}
