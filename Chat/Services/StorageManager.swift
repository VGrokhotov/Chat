//
//  StorageManager.swift
//  Chat
//
//  Created by Владислав on 28.03.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit
import CoreData

class StorageManager{
     
     lazy var container: NSPersistentContainer = {
          let appDelegate = UIApplication.shared.delegate as? AppDelegate
          if let appDelegate = appDelegate {
               return appDelegate.persistentContainer
          }
          return NSPersistentContainer()
     }()
     
     func save(name: String?, description: String?, imageData: Data?) {
          container.performBackgroundTask { (context) in
               
               //to have only one entity
               let fetchRequest = NSFetchRequest<User>(entityName: "User")
               let allUsers = try? context.fetch(fetchRequest)
               if let allUsers = allUsers {
                    for user in allUsers{
                         if user != allUsers[allUsers.count-1] {
                              context.delete(user)
                         }
                    }
               }
               
               let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User
               user?.userName = name
               user?.userDescription = description
               user?.userImageData = imageData
               
               try? context.save()
          }
     }
     
     
     func  readData() -> [Any?] {
          var name: String?
          var description: String?
          var imageData: Data?
          
          let fetchRequest = NSFetchRequest<User>(entityName: "User")
          let allUsers = try? container.viewContext.fetch(fetchRequest)
          //let allUsers = try? context.fetch(User.fetchRequest())
     
          let user = allUsers?.last
          name = user?.userName
          description = user?.userDescription
          imageData = user?.userImageData

          return [name, description, imageData]
     }
}
