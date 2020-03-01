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
                      ConversationCellModel(name: "User 4", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2017/10/08 22:31")! , isOnline: true, hasUnreadMessages: false),
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
                      ConversationCellModel(name: "User 18", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2015/10/08 22:31")! , isOnline: false, hasUnreadMessages: false),
                      ConversationCellModel(name: "User 19", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2014/10/08 22:31")! , isOnline: false, hasUnreadMessages: true),
                      ConversationCellModel(name: "User 20", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2013/10/08 22:31")! , isOnline: false, hasUnreadMessages: false),
                      ConversationCellModel(name: "User 21", message: "gggggggggggggg ff    fhfh", date: formatter.date(from: "2012/10/08 22:31")! , isOnline: false, hasUnreadMessages: false),
                    ]]
        
    }
    
    static func messages() -> [MessageCellModel]{
        return [MessageCellModel(text: "lol"), MessageCellModel(text: "ahah"), MessageCellModel(text: "no") ]
    }
}
