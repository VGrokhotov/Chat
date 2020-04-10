//
//  MessagesStorageManager.swift
//  Chat
//
//  Created by Владислав on 10.04.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit
import CoreData

protocol MessagesDataManager {
     
    func saveMessages(messages: [Message], completion: @escaping () -> ())
    func readMessages()
    
    var controller: NSFetchedResultsController<MessageObject> {get}
}

class MessagesStorageManager: MessagesDataManager{
    
    init(channelIdentifier: String){
        self.channelIdentifier = channelIdentifier
    }
    
    private var channelIdentifier: String
    
     private lazy var container: NSPersistentContainer = {
          
          let appDelegate = UIApplication.shared.delegate as? AppDelegate
          
          if let appDelegate = appDelegate {
               return appDelegate.persistentContainer
          }
          
          return NSPersistentContainer()
     }()
    
    
        
    lazy var controller: NSFetchedResultsController<MessageObject> = {
        
        let dateSort = NSSortDescriptor(key: "created", ascending: true)
        let predicate = NSPredicate(format: "channelIdentifier == %@", channelIdentifier)
        let fetchRequest = NSFetchRequest<MessageObject>(entityName: "MessageObject")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [dateSort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
    }()
     
     
     
     func readMessages(){

        let dateSort = NSSortDescriptor(key: "created", ascending: true)
        let predicate = NSPredicate(format: "channelIdentifier == %@", channelIdentifier)
        
        let fetchRequest = NSFetchRequest<MessageObject>(entityName: "MessageObject")
        fetchRequest.sortDescriptors = [dateSort]
        fetchRequest.predicate = predicate
        
        //let allMessages = try? container.viewContext.fetch(fetchRequest)
          
     }
     
    func saveMessages(messages: [Message], completion: @escaping () -> ()) {
        container.performBackgroundTask { (context) in

            let predicate = NSPredicate(format: "channelIdentifier == %@", self.channelIdentifier)
            let fetchRequest = NSFetchRequest<MessageObject>(entityName: "MessageObject")
            fetchRequest.predicate = predicate
            
            guard let channelMessages = try? context.fetch(fetchRequest) else {return}
        
            for message in messages{
                var currentMessageObject: MessageObject?
                
                for messageObject in channelMessages{
                    if message.created == messageObject.created{
                        currentMessageObject = messageObject
                        break
                    }
                }
                
                if let _ = currentMessageObject {
                    continue
                } else {
                    currentMessageObject = NSEntityDescription.insertNewObject(forEntityName: "MessageObject", into: context) as? MessageObject
                }
                
                currentMessageObject?.channelIdentifier = message.channelIdentifier
                currentMessageObject?.content = message.content
                currentMessageObject?.created = message.created
                currentMessageObject?.senderID = message.senderID
                currentMessageObject?.senderName = message.senderName
                
            }
            
            try? context.save()
            completion()
        }
     }
}
