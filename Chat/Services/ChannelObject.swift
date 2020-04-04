//
//  ChannelObject.swift
//  Chat
//
//  Created by Владислав on 04.04.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//
import UIKit
import CoreData

@objc(ChannelObject)
class ChannelObject: NSManagedObject {
    
    @NSManaged public var identifier: String
    @NSManaged public var name: String
    @NSManaged public var lastMessage: String
    @NSManaged public var lastActivity: Date?

        
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChannelObject> {
        return NSFetchRequest<ChannelObject>(entityName: "ChannelObject");
    }
    

}
