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
        
        return      [[ConversationCellModel(name: "Ann", message: "how do you do?", date: formatter.date(from: "2020/03/15 22:31"), isOnline: true, hasUnreadMessages: false),
                      ConversationCellModel(name: "Dima", message: "ahahahahahahahhahahahahahahahahahahahahahahahahah", date: formatter.date(from: "2020/03/15 18:01"), isOnline: true, hasUnreadMessages: false),
                      ConversationCellModel(name: "Max", message: "ahahahahahahahahahahhahahahahahahahahahahahahahaha", date: formatter.date(from: "2020/03/15 12:31"), isOnline: true, hasUnreadMessages: true),
                      ConversationCellModel(name: "Basil", message: nil, date: formatter.date(from: "2020/03/15 12:30") , isOnline: true, hasUnreadMessages: false),
                      ConversationCellModel(name: "Evgen", message: "hi", date: formatter.date(from: "2020/03/15 11:00") , isOnline: true, hasUnreadMessages: false),
                      ConversationCellModel(name: "Sveta", message: "good", date: formatter.date(from: "2020/02/08 22:31") , isOnline: true, hasUnreadMessages: false),
                      ConversationCellModel(name: "Mark", message: "not good", date: formatter.date(from: "2020/01/01 22:31"), isOnline: true, hasUnreadMessages: true),
                      ConversationCellModel(name: "Andrey", message: "hey", date: formatter.date(from: "2019/12/08 22:31"), isOnline: true, hasUnreadMessages: true),
                      ConversationCellModel(name: "Sanya", message: "hello", date: formatter.date(from: "2012/01/08 22:31"), isOnline: true, hasUnreadMessages: false),
                      ConversationCellModel(name: "Anton", message: "oh my god", date: formatter.date(from: "2011/06/08 22:31"), isOnline: true, hasUnreadMessages: true),
                    ],
                     [ConversationCellModel(name: "Masha", message: "300$", date: formatter.date(from: "2020/02/29 22:31"), isOnline: false, hasUnreadMessages: false),
                      ConversationCellModel(name: "Olga", message: "lol", date: formatter.date(from: "2020/02/27 22:31"), isOnline: false, hasUnreadMessages: true),
                      ConversationCellModel(name: "Danya", message: "my leg is broken", date: formatter.date(from: "2020/02/21 22:31"), isOnline: false, hasUnreadMessages: false),
                      ConversationCellModel(name: "Igor", message: "I am very tired", date: formatter.date(from: "2019/07/06 22:31"), isOnline: false, hasUnreadMessages: false),
                      ConversationCellModel(name: "Lena", message: "ok", date: formatter.date(from: "2018/05/23 22:31"), isOnline: false, hasUnreadMessages: false),
                      ConversationCellModel(name: "Yarik", message: "see u soon", date: formatter.date(from: "2017/01/31 22:31"), isOnline: false, hasUnreadMessages: false),
                      ConversationCellModel(name: "Artem", message: "welcome to the club, body", date: formatter.date(from: "2016/10/08 22:31"), isOnline: false, hasUnreadMessages: true),
                      ConversationCellModel(name: "Kirill", message: nil, date: formatter.date(from: "2015/12/08 22:31"), isOnline: false, hasUnreadMessages: false),
                      ConversationCellModel(name: "Oleg", message: "where r u?", date: formatter.date(from: "2014/10/18 22:31"), isOnline: false, hasUnreadMessages: true),
                      ConversationCellModel(name: "Sasha", message: "I am here", date: formatter.date(from: "2013/09/28 22:31"), isOnline: false, hasUnreadMessages: false),
                      ConversationCellModel(name: "Polina", message: "it is freaking embarrassment", date: formatter.date(from: "2012/10/08 22:31"), isOnline: false, hasUnreadMessages: false),
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
