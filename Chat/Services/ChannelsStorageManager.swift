//
//  ChannelsStorageManager.swift
//  Chat
//
//  Created by Владислав on 05.04.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit
import CoreData

protocol ChannelsDataManager {
     
    func saveChannels(channels: [Channel], complition: @escaping () -> ())
    func readChannels()
     
}

class ChannelsStorageManager: ChannelsDataManager{

     private lazy var container: NSPersistentContainer = {
          
          let appDelegate = UIApplication.shared.delegate as? AppDelegate
          
          if let appDelegate = appDelegate {
               return appDelegate.persistentContainer
          }
          
          return NSPersistentContainer()
     }()
     
     
     
     func readChannels(){

          let dateSort = NSSortDescriptor(key: "lastActivity", ascending: false)
          
          let fetchRequest = NSFetchRequest<ChannelObject>(entityName: "ChannelObject")
          fetchRequest.sortDescriptors = [dateSort]
          
          //let allChannels = try? container.viewContext.fetch(fetchRequest)
          
     }
     
     func saveChannels(channels: [Channel], complition: @escaping () -> ()) {
        container.performBackgroundTask { (context) in
            
//            print(channels.count)
            //to have only one entity
            let fetchRequest = NSFetchRequest<ChannelObject>(entityName: "ChannelObject")
            let allChannels = try? context.fetch(fetchRequest)
            //print(allChannels?.count)
            if let allChannels = allChannels {
                 if allChannels.count > 0{
                      for channel in allChannels{
                        context.delete(channel)
                      }
                 }
            }
            for channel in channels{
                let channelObject = NSEntityDescription.insertNewObject(forEntityName: "ChannelObject", into: context) as? ChannelObject
                
                channelObject?.identifier = channel.identifier
                channelObject?.lastMessage = channel.lastMessage
                channelObject?.lastActivity = channel.lastActivity
                channelObject?.name = channel.name
                channelObject?.section = "Not Active"
            }
            
            try? context.save()
            complition()
        }
     }
}
