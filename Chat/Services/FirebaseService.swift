//
//  FirebaseService.swift
//  Chat
//
//  Created by Владислав on 22.03.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit
import Firebase

protocol DataManager{
    
    func getChannels(completion: @escaping ([Channel]) -> ())
    
    func getMessages(channel: Channel, completion: @escaping ([Message]) -> ())
    
    func sendMessage(message: Message, completion: @escaping () -> ())
    
    func createChannel(channel: Channel, completion: @escaping () -> ())
    
    var channelsReloadCompletion: () -> ()  { get }
}

class FirebaseDataManager: DataManager{
    
    
    
    private lazy var db = Firestore.firestore()
    private lazy var channelsReference = db.collection("channels")
    private lazy var messageReference: CollectionReference = messageReferenceFunc()
    
    private func messageReferenceFunc() -> CollectionReference {
            guard let channelIdentifier = channel?.identifier else { fatalError() }
            return db.collection("channels").document(channelIdentifier).collection("messages")
    }
    
    var channelsReloadCompletion: () -> ()
    
    var channel: Channel?
    
    
    init(channelsReloader: @escaping () -> ()) {
        self.channelsReloadCompletion = channelsReloader
    }
    
    
    
    func getChannels(completion: @escaping ([Channel]) -> () ) {
        channelsReference.addSnapshotListener{ [weak self] snapshot, error in
            if let snapshot = snapshot{
                var channels = [Channel]()
                for document in snapshot.documents{
                   
                    let name = document.data()["name"] as? String
                    let lastMessage = document.data()["lastMessage"] as? String
                    let lastActivityData = document.data()["lastActivity"] as? Timestamp
                    let lastActivity = lastActivityData?.dateValue()
                    var section: String?
                    
                    if let lastActivity = lastActivity{
                        let  lastActivityPlusTenMinutes = lastActivity.addingTimeInterval(600)
                        if lastActivityPlusTenMinutes > Date(){
                            section = "Active"
                            if let dataManager = self{
                                let timer = Timer(fireAt: lastActivityPlusTenMinutes, interval: 0, target: dataManager, selector: #selector(self?.reloadChannelsTableView), userInfo: nil, repeats: false)
                                RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
                                
                            }
                        } else {
                            section = "Not Active"
                        }
                    }
                    
                    let channel = Channel(identifier: document.documentID, name: name ?? "default", lastMessage: lastMessage ?? "new one", lastActivity: lastActivity, section: section ?? "Unknown")
                    
                    channels.append(channel)
                }

                completion(channels)
            }
        }
    }
    
    @objc func reloadChannelsTableView() {
        channelsReloadCompletion()
    }
    
    func getMessages(channel: Channel, completion: @escaping ([Message]) -> ()){
        self.channel = channel
        messageReference = messageReferenceFunc()
        messageReference.addSnapshotListener { snapshot, error in
            if let snapshot = snapshot{
                var messages = [Message]()
                for document in snapshot.documents{
                   
                    let content = document.data()["content"] as? String
                    let senderID = document.data()["senderID"] as? String
                    let createdData = document.data()["created"] as? Timestamp
                    let created = createdData?.dateValue()
                    let senderName = document.data()["senderName"] as? String
                    
                    let message = Message(content: content ?? "Nil", created: created ?? Date.distantPast, senderID: senderID ?? "1", senderName: senderName ?? "Default", channelIdentifier: channel.identifier)
                    
                    messages.append(message)
                }
                
//                messages.sort(by: { (firstMessage, secondMessage) -> Bool in
//                    return firstMessage.created < secondMessage.created
//
//                })
                
                completion(messages)
            }
        }
    }
    
    func sendMessage(message: Message, completion: @escaping () -> ()){
        messageReference.addDocument(data: message.toDict)
        completion()
    }
    
    func createChannel(channel: Channel, completion: @escaping () -> ()){
        channelsReference.addDocument(data: channel.toDict)
        completion()
    }
    
    
}
