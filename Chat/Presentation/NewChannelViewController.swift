//
//  NewChannelViewController.swift
//  Chat
//
//  Created by Владислав on 21.03.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class NewChannelViewController: UIViewController {
    
    @IBOutlet weak var newChannelNameTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    private var dataManager: DataManager?
    
    
    @IBAction func createButtonPressed(_ sender: Any) {
        guard let name = newChannelNameTextField.text else { return }
        
        let channel = Channel(identifier: "",
                              name: name,
                              lastMessage: "",
                              lastActivity: nil,
                              section: "")
        
        dataManager?.createChannel(channel: channel) {
            self.dataManager?.reloadCompletion()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    static func makeVC(dataManager: DataManager) -> NewChannelViewController {
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: NewChannelViewController.self)) as? NewChannelViewController
        
        guard let newVC = newViewController else {return NewChannelViewController()}

        newVC.dataManager = dataManager
        
        return newVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToHideKeyboardOnTapOnView()
        
        registerForKeyboardNotification()
        
        createButton.isEnabled = false
        
        newChannelNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)

        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        title = "New channel"
        
        newChannelNameTextField.delegate = self

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
       createButton.layer.cornerRadius = 10
       createButton.layer.borderWidth = 2.0
       createButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
       createButton.clipsToBounds = true
    }
    
    deinit {
        removeKeyboardNotification()
    }

}

// MARK: - Text field delegate

extension NewChannelViewController: UITextFieldDelegate{
    //To close the keyboard after Done pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged(){
        
        if newChannelNameTextField.text?.count == 0{
            createButton.isEnabled = false
        } else {
            createButton.isEnabled = true
        }
    }
}



//MARK: Show the content above the keyboard

extension NewChannelViewController{
    
    func registerForKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
                self.view.frame.size.height -= keyboardSize.size.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            self.view.frame.size.height += keyboardSize.size.height
        }
    }
}
