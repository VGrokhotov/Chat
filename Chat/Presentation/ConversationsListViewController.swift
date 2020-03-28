//
//  ConversationsListViewController.swift
//  Chat
//
//  Created by Владислав on 29.02.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var dataManager: DataManager = FirebaseDataManager(conversationsListViewController: self)
    
    var channels: [Channel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.getChannels()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: String(describing: ConversationCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: ConversationCell.self))
        
        title = "Tinkoff Chat"
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        let destinationViewController = ProfileViewController.makeVC()
        present(destinationViewController, animated: true)
    }
    
    @IBAction func createChannelButtonPressed(_ sender: Any) {
        
        let destinationViewController = NewChannelViewController.makeVC(dataManager: dataManager)
        
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
}

//MARK: Work with table

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Active"
        }
        else{
            return "Not Active"
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var currentChannel: Channel = Channel(identifier: "", name: "", lastMessage: "", lastActivity: Date())
        
        if indexPath.section == 0 {
            var active = 0
            for channel in channels ?? []{
                if let lastActivity = channel.lastActivity{
                    if Date().timeIntervalSince(lastActivity) < 600.0 {
                        active += 1
                        if indexPath.row == active - 1 {
                            currentChannel = channel
                            break
                        }
                    }
                }
            }
        } else {
            var notActive = 0
            for channel in channels ?? []{
                if let lastActivity = channel.lastActivity {
                    if Date().timeIntervalSince(lastActivity) > 599.99999999 {
                        notActive += 1
                        if indexPath.row == notActive - 1 {
                            currentChannel = channel
                            break
                        }
                    }
                } else {
                    notActive += 1
                    if indexPath.row == notActive - 1 {
                        currentChannel = channel
                        break
                    }
                }
            }
        }
        
        
        let destinationViewController = ConversationViewController.makeVC(with: currentChannel, dataManager: dataManager)
        
        dataManager.addReference(with: destinationViewController)
        
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            var active = 0
            for channel in channels ?? []{
                if let lastActivity = channel.lastActivity{
                    if Date().timeIntervalSince(lastActivity) < 600.0 {
                        active += 1
                    }
                }
            }
            return active
        } else {
            var notActive = 0
            for channel in channels ?? []{
                if let lastActivity = channel.lastActivity{
                    if Date().timeIntervalSince(lastActivity) > 599.99999999 {
                        notActive += 1
                    }
                } else {
                    notActive += 1
                }
            }
            return notActive
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: ConversationCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationCell else { return ConversationCell() }
        
        
        if indexPath.section == 0 {
            var active = 0
            for channel in channels ?? []{
                if let lastActivity = channel.lastActivity{
                    if Date().timeIntervalSince(lastActivity) < 600.0 {
                        active += 1
                        if indexPath.row == active - 1 {
                            cell.configure(with: channel)
                            return cell
                        }
                    }
                }
            }
            return ConversationCell()
        } else {
            var notActive = 0
            for channel in channels ?? []{
                if let lastActivity = channel.lastActivity{
                    if Date().timeIntervalSince(lastActivity) > 599.99999999 {
                        notActive += 1
                        if indexPath.row == notActive - 1 {
                            cell.configure(with: channel)
                            return cell
                        }
                    }
                } else {
                    notActive += 1
                    if indexPath.row == notActive - 1 {
                        cell.configure(with: channel)
                        return cell
                    }
                }
            }
            return ConversationCell()
        }
    }
}

