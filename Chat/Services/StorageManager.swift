//
//  StorageManager.swift
//  Chat
//
//  Created by Владислав on 28.03.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit
import CoreData

protocol ProfileDataManager {
     
     func saveData(name: String?, description: String?, imageData: Data?, hasNameChanged: Bool, hasDescriptionChanged: Bool, hasImageChanged: Bool, complition: @escaping (Bool) -> () )
     
     func readData() -> [Any?]
     
}

class StorageManager: ProfileDataManager{

     private lazy var container: NSPersistentContainer = {
          
          let appDelegate = UIApplication.shared.delegate as? AppDelegate
          
          if let appDelegate = appDelegate {
               return appDelegate.persistentContainer
          }
          
          return NSPersistentContainer()
     }()
     
     func saveData(name: String?, description: String?, imageData: Data?, hasNameChanged: Bool, hasDescriptionChanged: Bool, hasImageChanged: Bool, complition: @escaping (Bool) -> () ) {
          
          // I am sure that someyhing has changed because save button is not Active untill somthing changed
          container.performBackgroundTask { (context) in
               
               //to have only one entity
               let fetchRequest = NSFetchRequest<User>(entityName: "User")
               let allUsers = try? context.fetch(fetchRequest)
               if let allUsers = allUsers {
                    
                    if allUsers.count > 0{
                         
                         for user in allUsers{
                              if user != allUsers[allUsers.count-1] {
                                   context.delete(user)
                              }
                         }
                         
                         let user = allUsers.last
                         
                         if hasNameChanged {
                              user?.userName = name
                         }
                         if hasDescriptionChanged{
                              user?.userDescription = description
                         }
                         if hasImageChanged{
                              user?.userImageData = imageData
                         }
                         
                    } else {
                         
                         let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User
                         
                         user?.userName = name
                         user?.userDescription = description
                         user?.userImageData = imageData
                         
                    }
               }
               do {
                    try context.save()
                    DispatchQueue.main.async {
                         complition(true)
                    }
               } catch {
                    DispatchQueue.main.async {
                         complition(false)
                    }
               }
               
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
