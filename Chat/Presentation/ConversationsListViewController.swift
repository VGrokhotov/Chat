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
    
    var storageManager: ChannelsDataManager = ChannelsStorageManager()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        storageManager.controller.delegate = self
        
        readDataFromDBAndSaveToCoreData()

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
    
    func readDataFromDBAndSaveToCoreData(){
        dataManager.getChannels() { (channels) in
            
            self.storageManager.saveChannels(channels: channels) {
                DispatchQueue.main.async {
                    try? self.storageManager.controller.performFetch()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

//MARK: Work with table

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = storageManager.controller.sections else { return "" }
        return sections[section].name
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let channelObject = storageManager.controller.object(at: indexPath)
        let channel = channelObject.toChannel()
        
        let destinationViewController = ConversationViewController.makeVC(with: channel, dataManager: dataManager)
        
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

extension ConversationsListViewController: UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = storageManager.controller.sections else { return 0 }
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = storageManager.controller.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let channelObject = storageManager.controller.object(at: indexPath)
        
        let identifier = String(describing: ConversationCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationCell else { return ConversationCell() }
        
        
        let channel = channelObject.toChannel()
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
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
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
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                let channelObject = storageManager.controller.object(at: indexPath)
                guard let cell = tableView.cellForRow(at: indexPath) as? ConversationCell else { break }
                let channel = channelObject.toChannel()
                cell.configure(with: channel)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
        
    }
    
}
