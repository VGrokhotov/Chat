//
//  MessagesService.swift
//  Chat
//
//  Created by Владислав on 15.04.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class MessagesService {
    
    private var storageManager: MessagesDataManager
    
    init(channelIdentifier: String){
        storageManager = MessagesStorageManager(channelIdentifier: channelIdentifier)
    }
    
    func saveMessages(messages: [Message], completion: @escaping () -> ()) {
        storageManager.saveMessages(messages: messages, completion: completion)
    }
    
    func deleteMessagesForChannel() {
        storageManager.deleteMessagesForChannel()
    }
    
    func object(at indexPath: IndexPath) -> Message {
        return storageManager.object(at: indexPath)
    }
    
    func fetch() {
        storageManager.fetch()
    }
    
    func sectionName(section: Int) -> String {
        return storageManager.sectionName(section: section)
    }
    
    func numberOfSections() -> Int {
        return storageManager.numberOfSections()
    }
    
    func numberOfRowsIn(section: Int) -> Int {
        return storageManager.numberOfRowsIn(section: section)
    }
    
    func setDelegat(viewController: UIViewController) {
        storageManager.setDelegat(viewController: viewController)
    }
    
    func amountOfMessages() -> Int? {
        return storageManager.amountOfMessages()
    }
    
}
