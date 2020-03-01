//
//  ConversationViewController.swift
//  Chat
//
//  Created by Владислав on 29.02.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var conversationData: ConversationCellModel?
    
    var messages: [MessageCellModel] = StorageManager.messages()
    
    static func makeVC(with data: ConversationCellModel) -> ConversationViewController {
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ConversationViewController.self)) as? ConversationViewController
        
        guard let newVC = newViewController else {return ConversationViewController()}
        
        newVC.conversationData = data

        return newVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        if conversationData != nil {
            title = conversationData!.name
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: String(describing: MessageCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: MessageCell.self))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.reloadData()
    }

}

//MARK: Work with table

extension ConversationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)    }
    
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: MessageCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell else { return UITableViewCell() }
        
        cell.configure(with: messages[indexPath.row])
        
        return cell
    }
    
    
}

