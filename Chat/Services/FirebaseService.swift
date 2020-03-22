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
    
    func getChannels()
    
    func getMessages(channel: Channel)
    
    func sendMessage(message: Message)
    
    func addReference(with cVC: ConversationViewController)
}

class FirebaseDataManager: DataManager{
    
    
    
    private lazy var db = Firestore.firestore()
    private lazy var channelsReference = db.collection("channels")
    private lazy var messageReference: CollectionReference = messageReferenceFunc()
    
    private func messageReferenceFunc() -> CollectionReference {
            guard let channelIdentifier = channel?.identifier else { fatalError() }
            return db.collection("channels").document(channelIdentifier).collection("messages")
    }
    
    var channel: Channel?
    
    weak var clVC: ConversationsListViewController?
    weak var cVC: ConversationViewController?
    
    init(conversationsListViewController clVC: ConversationsListViewController) {
        self.clVC = clVC
    }
    
    func addReference(with cVC: ConversationViewController) {
        self.cVC = cVC
    }
    
    
    
    func getChannels() {
        channelsReference.addSnapshotListener{ [weak self] snapshot, error in
            if let snapshot = snapshot{
                self?.clVC?.channels = []
                for document in snapshot.documents{
                   
                    let name = document.data()["name"] as? String
                    let lastMessage = document.data()["lastMessage"] as? String
                    let lastActivityData = document.data()["lastActivity"] as? Timestamp
                    let lastActivity = lastActivityData?.dateValue()
                    
                    if let lastActivity = lastActivity{
                        let  lastActivityPlusTenMinutes = lastActivity.addingTimeInterval(600)
                        if lastActivityPlusTenMinutes > Date(){
                            if let dataManager = self{
                            let timer = Timer(fireAt: lastActivityPlusTenMinutes, interval: 0, target: dataManager, selector: #selector(self?.reloadChannelsTableWiew), userInfo: nil, repeats: false)
                                RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
                                
                            }
                        }
                    }
                    
                    let channel = Channel(identifier: document.documentID, name: name ?? "default", lastMessage: lastMessage ?? "new one", lastActivity: lastActivity)
                    
                    self?.clVC?.channels?.append(channel)
                }
                self?.clVC?.channels?.sort(by: { (firstChannel, secondChannel) -> Bool in
                    if let firstActivity = firstChannel.lastActivity{
                        if let secondActivity = secondChannel.lastActivity {
                            return firstActivity > secondActivity
                        }
                        else {
                            return true
                        }
                    } else {
                        if let _ = secondChannel.lastActivity {
                            return false
                        }
                        else {
                            return true
                        }
                    }
                    
                })
                self?.clVC?.tableView.reloadData()
            }
        }
    }
    
    @objc func reloadChannelsTableWiew() {
        clVC?.tableView.reloadData()
    }
    
    func getMessages(channel: Channel){
        self.channel = channel
        messageReference = messageReferenceFunc()
        messageReference.addSnapshotListener { [weak self] snapshot, error in
            if let snapshot = snapshot{
                self?.cVC?.messages = []
                for document in snapshot.documents{
                   
                    let content = document.data()["content"] as? String
                    let senderId = document.data()["senderID"] as? String
                    let createdData = document.data()["created"] as? Timestamp
                    let created = createdData?.dateValue()
                    let senderName = document.data()["senderName"] as? String
                    
                    let message = Message(content: content ?? "Nil", created: created ?? Date.distantPast, senderId: senderId ?? "1", senderName: senderName ?? "Default")
                    
                    self?.cVC?.messages?.append(message)
                }
                
                self?.cVC?.messages?.sort(by: { (firstMessage, secondMessage) -> Bool in
                    return firstMessage.created < secondMessage.created
                    
                })
                
                self?.cVC?.tableView.reloadData()
            }
        }
    }
    
    func sendMessage(message: Message){
        messageReference.addDocument(data: message.toDict)
        cVC?.tableView.reloadData()
    }
    
    
}
