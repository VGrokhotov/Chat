//
//  ConversationsListViewController.swift
//  Chat
//
//  Created by Владислав on 29.02.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var dataManager: DataManager = FirebaseDataManager(channelsReloader: {
        self.tableView.reloadData()
    })
    
    var channels: [Channel]?
    
    var storageManager: ChannelsDataManager = ChannelsStorageManager()
    
    var fetchedResultsController : NSFetchedResultsController<ChannelObject>?
    private lazy var container: NSPersistentContainer = {
         
         let appDelegate = UIApplication.shared.delegate as? AppDelegate
         
         if let appDelegate = appDelegate {
              return appDelegate.persistentContainer
         }
         
         return NSPersistentContainer()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateSort = NSSortDescriptor(key: "lastActivity", ascending: false)
        let fetchRequest = NSFetchRequest<ChannelObject>(entityName: "ChannelObject")
        fetchRequest.sortDescriptors = [dateSort]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: container.viewContext,
            sectionNameKeyPath: "section",
            cacheName: nil)
        try? fetchedResultsController?.performFetch()
        fetchedResultsController?.delegate = self
        
        dataManager.getChannels() { (channels) in
            //self.channels = channels
            
            self.storageManager.saveChannels(channels: channels) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            //self.tableView.reloadData()
            
        }

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
        
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            var active = 0
//            for channel in channels ?? []{
//                if let lastActivity = channel.lastActivity{
//                    if Date().timeIntervalSince(lastActivity) < 600.0 {
//                        active += 1
//                    }
//                }
//            }
//            return active
//        } else {
//            var notActive = 0
//            for channel in channels ?? []{
//                if let lastActivity = channel.lastActivity{
//                    if Date().timeIntervalSince(lastActivity) > 599.99999999 {
//                        notActive += 1
//                    }
//                } else {
//                    notActive += 1
//                }
//            }
//            return notActive
//        }
//        
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let identifier = String(describing: ConversationCell.self)
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationCell else { return ConversationCell() }
//        
//        
//        if indexPath.section == 0 {
//            var active = 0
//            for channel in channels ?? []{
//                if let lastActivity = channel.lastActivity{
//                    if Date().timeIntervalSince(lastActivity) < 600.0 {
//                        active += 1
//                        if indexPath.row == active - 1 {
//                            cell.configure(with: channel)
//                            return cell
//                        }
//                    }
//                }
//            }
//            return ConversationCell()
//        } else {
//            var notActive = 0
//            for channel in channels ?? []{
//                if let lastActivity = channel.lastActivity{
//                    if Date().timeIntervalSince(lastActivity) > 599.99999999 {
//                        notActive += 1
//                        if indexPath.row == notActive - 1 {
//                            cell.configure(with: channel)
//                            return cell
//                        }
//                    }
//                } else {
//                    notActive += 1
//                    if indexPath.row == notActive - 1 {
//                        cell.configure(with: channel)
//                        return cell
//                    }
//                }
//            }
//            return ConversationCell()
//        }
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController?.sections else { return 0 }
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let channelObject = fetchedResultsController?.object(at: indexPath)
        
        let identifier = String(describing: ConversationCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationCell else { return ConversationCell() }
        
        
        guard let channel = channelObject?.toChannel() else { return ConversationCell() }
        cell.configure(with: channel)
        
        return cell
    }
}

//MARK: Work with NSFetchedResultsControllerDelegate

extension ConversationsListViewController: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        default:
            return
        }
        
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let channelObject = fetchedResultsController?.object(at: indexPath)
                guard let cell = tableView.cellForRow(at: indexPath) as? ConversationCell else { break }
                guard let channel = channelObject?.toChannel() else { return }
                cell.configure(with: channel)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
        
    }
    
}
