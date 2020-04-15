//
//  ChannelService.swift
//  Chat
//
//  Created by Владислав on 15.04.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class ChannelsService {
    
    private var storageManager: ChannelsDataManager = ChannelsStorageManager()
    
    func saveChannels(channels: [Channel], completion: @escaping () -> ()) {
        storageManager.saveChannels(channels: channels, completion: completion)
    }
    
    func object(at indexPath: IndexPath) -> Channel {
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
    
}
