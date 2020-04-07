//
//  User.swift
//  Chat
//
//  Created by Владислав on 28.03.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit
import CoreData

@objc(User)
class User: NSManagedObject {
    
    @NSManaged public var userName: String?
    @NSManaged public var userDescription: String?
    @NSManaged public var userImageData: Data?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

}
