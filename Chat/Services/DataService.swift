//
//  FirebaseService.swift
//  Chat
//
//  Created by Владислав on 15.04.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class DataService {
    
    private var dataManager: DataManager
    
    var channelsReloadCompletion: () -> ()
    
    init(channelsReloader: @escaping () -> ()) {
        dataManager = FirebaseDataManager(channelsReloader: channelsReloader)
        channelsReloadCompletion = channelsReloader
    }
    
    func getChannels(completion: @escaping ([Channel]) -> ()) {
        dataManager.getChannels(completion: completion)
    }
    
    func getMessages(channel: Channel, completion: @escaping ([Message]) -> ()) {
        dataManager.getMessages(channel: channel, completion: completion)
    }
    
    func sendMessage(message: Message, completion: @escaping () -> ()){
        dataManager.sendMessage(message: message, completion: completion)
    }
    
    func createChannel(channel: Channel, completion: @escaping () -> ()){
        dataManager.createChannel(channel: channel, completion: completion)
    }
    
    func deleteChannel(channel: Channel, completion: @escaping () -> (), errorCompletion: @escaping (String) -> ()){
        dataManager.deleteChannel(channel: channel, completion: completion, errorCompletion: errorCompletion)
    }
    
    
}
