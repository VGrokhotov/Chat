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
    
    private lazy var dataManager = DataService(channelsReloader: {
        self.tableView.reloadData()
    })
    
    var storageManager = ChannelsService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        storageManager.setDelegat(viewController: self)
        storageManager.fetch()
        tableView.reloadData()
        
        readDataFromDBAndSaveToCoreData()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: String(describing: ConversationCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: ConversationCell.self))
        
        title = "Tinkoff Chat"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
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
                    self.storageManager.fetch()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: Alerts

    func errorAlert(title: String, message: String){
        
        let allert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        allert.addAction(okAction)
        
        present(allert, animated: true)
    }
    
}


//MARK: Work with table

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return storageManager.sectionName(section: section)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let channel = storageManager.object(at: indexPath)
        
        let destinationViewController = ConversationViewController.makeVC(with: channel, dataManager: dataManager)
        
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let channel = storageManager.object(at: indexPath)
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (_, _, _) in
            let comletion = {
                let messageDataManager: MessagesDataManager = MessagesStorageManager(channelIdentifier: channel.identifier)
                messageDataManager.deleteMessagesForChannel()
            }
            self.dataManager.deleteChannel(channel: channel, completion: comletion) { (errorMessage) in
                DispatchQueue.main.async {
                    self.errorAlert(title: "Deleting error", message: errorMessage)
                }
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
}

extension ConversationsListViewController: UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return storageManager.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storageManager.numberOfRowsIn(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let channel = storageManager.object(at: indexPath)
        
        let identifier = String(describing: ConversationCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationCell else { return ConversationCell() }
        
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
                let channel = storageManager.object(at: indexPath)
                guard let cell = tableView.cellForRow(at: indexPath) as? ConversationCell else { break }
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
