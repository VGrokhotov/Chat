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
    
    func saveChannels(channels: [Channel], completion: @escaping () -> ())
    
    func object(at: IndexPath) -> Channel
    
    func fetch()
    
    func sectionName(section: Int) -> String
    
    func numberOfSections() -> Int
    
    func numberOfRowsIn(section: Int) -> Int
    
    func setDelegat(viewController: UIViewController)
    
}

class ChannelsStorageManager: ChannelsDataManager{
    
    private lazy var container: NSPersistentContainer = {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        if let appDelegate = appDelegate {
            return appDelegate.persistentContainer
        }
        
        return NSPersistentContainer()
    }()
    
    
    
    lazy var controller: NSFetchedResultsController<ChannelObject> = {
        
        let dateSort = NSSortDescriptor(key: "lastActivity", ascending: false)
        let sectionSort = NSSortDescriptor(key: "section", ascending: true)
        let fetchRequest = NSFetchRequest<ChannelObject>(entityName: "ChannelObject")
        fetchRequest.sortDescriptors = [sectionSort, dateSort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: container.viewContext,
            sectionNameKeyPath: "section",
            cacheName: nil)
        
        return fetchedResultsController
    }()
    
    
    func saveChannels(channels: [Channel], completion: @escaping () -> ()) {
        container.performBackgroundTask { (context) in
            
            let fetchRequest = NSFetchRequest<ChannelObject>(entityName: "ChannelObject")
            guard let allChannels = try? context.fetch(fetchRequest) else {return}
            
            var deleted = Array(repeating: true, count: allChannels.count)
            
            for channel in channels{
                
                var currentChannelObject: ChannelObject?
                
                for i in 0..<(allChannels.count){
                    if channel.identifier == allChannels[i].identifier{
                        currentChannelObject = allChannels[i]
                        deleted[i] = false
                        break
                    }
                }
                
                if let _ = currentChannelObject {
                    //
                } else {
                    currentChannelObject = NSEntityDescription.insertNewObject(forEntityName: "ChannelObject", into: context) as? ChannelObject
                }
                
                
                
                currentChannelObject?.identifier = channel.identifier
                currentChannelObject?.lastMessage = channel.lastMessage
                currentChannelObject?.lastActivity = channel.lastActivity
                currentChannelObject?.name = channel.name
                currentChannelObject?.section = channel.section
                
            }
            
            for i in 0..<deleted.count {
                if deleted[i] {
                    context.delete(allChannels[i])
                }
            }
            
            try? context.save()
            completion()
        }
    }
    
    func object(at indexPath: IndexPath) -> Channel {
        return controller.object(at: indexPath).toChannel()
    }
    
    func fetch() {
        try? controller.performFetch()
    }
    
    func sectionName(section: Int) -> String {
        return controller.sections?[section].name ?? ""
    }
    
    func numberOfSections() -> Int {
        return controller.sections?.count ?? 0
    }
    
    func numberOfRowsIn(section: Int) -> Int {
        return controller.sections?[section].numberOfObjects ?? 0
    }
    
    func setDelegat(viewController: UIViewController) {
        controller.delegate = viewController as? NSFetchedResultsControllerDelegate
    }
}
