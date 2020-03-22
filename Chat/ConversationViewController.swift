//
//  ConversationViewController.swift
//  Chat
//
//  Created by Владислав on 29.02.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit
import Firebase

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    private var dataManager: DataManager?
    
    var channel: Channel?
    
    var messages: [Message]?
    
    var userId = "vgrokhotov"
    var userName = "Vlad Grokhotov"
    
    var initLoad = true
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if let message = messageTextField.text {
            let newMessage = Message(content: message, created: Date(), senderId: userId, senderName: userName)
            
            dataManager?.sendMessage(message: newMessage)
            
            messageTextField.text = ""
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
        
        if let channel = channel{
            dataManager?.getMessages(channel: channel)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        messageTextField.delegate = self
        
        tableView.register(UINib(nibName: String(describing: MessageCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: MessageCell.self))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if initLoad{
            initLoad = false
            
            DispatchQueue.main.async { [weak self] in
                self?.scrollDown(animated: false)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
        
        if let messages = self.messages{
            
            if messages.count > 0 {
                let lastIndex = IndexPath(row: messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: animated)
            }
            
        }
        
    }
    
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let messages = messages{
            return messages.count
        }
        
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = String(describing: MessageCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell else { return MessageCell() }
        
        if let messages = messages{
            cell.configure(with: messages[indexPath.row])
            return cell
        }
        
        return MessageCell()
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
