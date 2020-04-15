//
//  ConversationViewController.swift
//  Chat
//
//  Created by Владислав on 29.02.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    private var dataManager: DataManager?
    
    lazy var storageManager: MessagesDataManager = MessagesStorageManager(channelIdentifier: channel?.identifier ?? "default")
    
    var channel: Channel?
    
    var userId = "vgrokhotov"
    var userName = "Vlad Grokhotov"
    
    var initLoad = true
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if let message = messageTextField.text, let channel = channel {
            let newMessage = Message(content: message, created: Date(), senderID: userId, senderName: userName, channelIdentifier: channel.identifier)
            
            dataManager?.sendMessage(message: newMessage){
                self.tableView.reloadData()
            }
            
            messageTextField.text = ""
            sendButton.isEnabled = false
            scrollDown(animated: true)
        }
    }
    
    
    
    static func makeVC(with data: Channel, dataManager: DataManager) -> ConversationViewController {

        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ConversationViewController.self)) as? ConversationViewController
        
        guard let newVC = newViewController else {return ConversationViewController()}
        
        newVC.dataManager = dataManager
        newVC.channel = data

        return newVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        storageManager.setDelegat(viewController: self)
        storageManager.fetch()
        tableView.reloadData()

        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        if let channel = channel{
            title = channel.name
        }
        
        messageTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        sendButton.isEnabled = false
        
        setupToHideKeyboardOnTapOnView()
        
        registerForKeyboardNotification()
        
        readDataFromDBAndSaveToCoreData()
        
        tableView.delegate = self
        tableView.dataSource = self
        messageTextField.delegate = self
        
        tableView.register(UINib(nibName: String(describing: MessageCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: MessageCell.self))
        
    }
    
    func readDataFromDBAndSaveToCoreData(){
        if let channel = channel{
            dataManager?.getMessages(channel: channel){ messages in
                
                self.storageManager.saveMessages(messages: messages){
                    DispatchQueue.main.async {
                        self.storageManager.fetch()
                        self.tableView.reloadData()
                        self.scrollDown(animated: false)
                    }
                }
            }
        }
    }
    
    deinit {
        removeKeyboardNotification()
    }

}

//MARK: Work with table

extension ConversationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //To scroll down the table
    
    func scrollDown(animated: Bool){
        guard let amountOfMessages =  storageManager.amountOfMessages() else { return }
        
        if amountOfMessages > 0 {
            let lastIndex = IndexPath(row: amountOfMessages - 1, section: 0)
            self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: animated)
        }
        
    }
    
}

extension ConversationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return storageManager.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storageManager.numberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = storageManager.object(at: indexPath)
        
        let identifier = String(describing: MessageCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell else { return MessageCell() }
        
        cell.configure(with: message)
        
        return cell
    }
    
    
}

//MARK: Work with NSFetchedResultsControllerDelegate

extension ConversationViewController: NSFetchedResultsControllerDelegate{
    
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
                let message = storageManager.object(at: indexPath)
                guard let cell = tableView.cellForRow(at: indexPath) as? MessageCell else { break }
                cell.configure(with: message)
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


// MARK: - Text field delegate

extension ConversationViewController: UITextFieldDelegate{
    //To close the keyboard after Done pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged(){
        if messageTextField.text?.count == 0{
            sendButton.isEnabled = false
        }
        else{
            sendButton.isEnabled = true
        }
    }
}


//MARK: Show the content above the keyboard

extension ConversationViewController{
    
    func registerForKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y + keyboardSize.size.height), animated: true)
            self.view.frame.size.height -= keyboardSize.size.height
            
        }
    }
    

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.size.height += keyboardSize.size.height
            //tableView.setContentOffset(CGPoint(x: 0, y:             tableView.contentOffset.y - keyboardSize.height), animated: true)
        }
    }
}
