//
//  MessageObject.swift
//  Chat
//
//  Created by Владислав on 04.04.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit
import CoreData

@objc(MessageObject)
class MessageObject: NSManagedObject {
    
    @NSManaged public var content: String
    @NSManaged public var created: Date
    @NSManaged public var senderID: String
    @NSManaged public var senderName: String
        
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageObject> {
        return NSFetchRequest<MessageObject>(entityName: "MessageObject");
    }
    

}
