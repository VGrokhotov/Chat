//
//  ViewController.swift
//  Chat
//
//  Created by Владислав on 16.02.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Vars and Lets
    
    var storageManager: ProfileDataManager = ProfileStorageManager()
    
    var hasNameChanged = false
    var hasDescriptionChanged = false
    var hasImageChanged = false


    // MARK: - IBActions
    
    @IBAction func cancelProfile(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    
    @IBAction func choosePhotoButtonAction(_ sender: Any) {
        showPhotoActionSheet()
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        switchToEditting()
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        
        willSwitchToViewMode()
        
        saveData()
        
    }
    
    func saveData(){
        
        storageManager.saveData(
            name: nameTextField.text,
            description: descriptionTextView.text,
            imageData: profileImageView.image?.pngData(),
            hasNameChanged: hasNameChanged,
            hasDescriptionChanged: hasDescriptionChanged,
            hasImageChanged: hasImageChanged,
            complition: { hasSaved in
                if hasSaved {
                    self.SuccessAlert(title: "Successfully saved!", message: "All information changed successfully")
                } else {
                    self.AlertWithRetry(title: "Saving failed", message: "Could not sava data")
                }
        }
        )
    }
    
    
    //MARK: Satic func
    
    static func makeVC() -> ProfileViewController {
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ProfileViewController.self)) as? ProfileViewController
        
        guard let newVC = newViewController else {return ProfileViewController()}

        return newVC
    }
    
    //MARK: Alert controllers
    
    func SuccessAlert(title: String, message: String){
        
        activityIndicator.stopAnimating()
        
        let allert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.didSwitchToViewMode()
        }
        
        allert.addAction(okAction)
        present(allert, animated: true)
    }
    
    func AlertWithRetry(title: String, message: String){
        
        activityIndicator.stopAnimating()
        enableButtons()
        
        let allert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            self.saveData()
        }
        
        allert.addAction(okAction)
        allert.addAction(retryAction)
        present(allert, animated: true)
    }
    
    //MARK: View DidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.contentMode = .scaleAspectFill
        
        activityIndicator.startAnimating()

        let data = storageManager.readData()
        
        if let name = data[0] as? String {
            nameLabel.text = name
        } else {
            nameLabel.text = "Default"
        }
        
        if let description = data[1] as? String {
            descriptionLabel.text = description
        } else {
            descriptionLabel.text = "Default"
        }
        
        if let imageData = data[2] as? Data{
             profileImageView.image = UIImage(data: imageData)
        } else {
            profileImageView.image = #imageLiteral(resourceName: "placeholder-user")
        }

        activityIndicator.stopAnimating()
        
        setupToHideKeyboardOnTapOnView()
        
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        registerForKeyboardNotification()
        
        editButton.layer.cornerRadius = 10
        editButton.layer.borderWidth = 2.0
        editButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        editButton.clipsToBounds = true
        
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderWidth = 2.0
        saveButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        saveButton.clipsToBounds = true
        
        nameTextField.delegate = self
        descriptionTextView.delegate = self

    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        choosePhotoButton.layer.cornerRadius = choosePhotoButton.frame.size.height / 2
        choosePhotoButton.imageView?.contentMode = .scaleAspectFit
        choosePhotoButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        choosePhotoButton.clipsToBounds = true
        
        profileImageView.layer.cornerRadius = choosePhotoButton.layer.cornerRadius
        
    }

}

// MARK: - Switching of mode

extension ProfileViewController{
    
    func hide(view: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 0
        }) { (finished) in
            view.isHidden = finished
        }
    }
    
    func show(view: UIView) {
        view.alpha = 0
        view.isHidden = false
        UIView.animate(withDuration: 0.6) {
            view.alpha = 1
        }
    }
    
    func enableButtons() {
        choosePhotoButton.isEnabled = true
        saveButton.isEnabled = true
    }
    
    func disableButtons(){
        choosePhotoButton.isEnabled = false
        saveButton.isEnabled = false
    }
    
    func disableSaveButtons(){
        saveButton.isEnabled = false
    }
    
    func enableSaveButtons() {
        saveButton.isEnabled = true
    }
    
    func switchToEditting() {
        nameTextField.text = nameLabel.text
        descriptionTextView.text = descriptionLabel.text
        
        enableButtons()
        disableSaveButtons()
        
        hide(view: nameLabel)
        hide(view: descriptionLabel)
        hide(view: editButton)
        
        show(view: choosePhotoButton)
        show(view: nameTextField)
        show(view: descriptionTextView)
        show(view: saveButton)
    }
    
    func willSwitchToViewMode() {
        disableButtons()
        activityIndicator.startAnimating()
    }
    
    func didSwitchToViewMode(){
        
        nameLabel.text = nameTextField.text
        descriptionLabel.text = descriptionTextView.text
        
        hasNameChanged = false
        hasDescriptionChanged = false
        hasImageChanged = false
        
        activityIndicator.stopAnimating()
        
        show(view: nameLabel)
        show(view: descriptionLabel)
        show(view: editButton)
        
        hide(view: choosePhotoButton)
        hide(view: nameTextField)
        hide(view: descriptionTextView)
        hide(view: saveButton)

    }
    
}


// MARK: - Work with image

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source){
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        profileImageView.image = info[.editedImage] as? UIImage
        
        if !hasNameChanged && !hasDescriptionChanged && !hasImageChanged{
            enableSaveButtons()
        }
        
        hasImageChanged = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true

        dismiss(animated: true)
    }
    
    func showPhotoActionSheet(){
        
        let cameraIcon = #imageLiteral(resourceName: "Camera")
        let photoIcon = #imageLiteral(resourceName: "Photo")

        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) {_ in
            self.chooseImagePicker(source: .camera)
        }
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)

        present(actionSheet, animated: true)
    }
}


//MARK: To dismiss keyboard after tapping anywhere else

extension UIViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

// MARK: - Text field delegate

extension ProfileViewController: UITextFieldDelegate{
    //To close the keyboard after Done pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged(){
        
        if !hasNameChanged && !hasDescriptionChanged && !hasImageChanged{
            enableSaveButtons()
        }
        
        hasNameChanged = true
        
        if nameTextField.text?.count == 0{
            disableSaveButtons()
        } else {
            enableSaveButtons()
        }
    }
}

//MARK: - Text View delegate

extension ProfileViewController: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        
        if !hasNameChanged && !hasDescriptionChanged && !hasImageChanged{
            enableSaveButtons()
        }
        
        hasDescriptionChanged = true
    }

}

//MARK: Show the content above the keyboard

extension ProfileViewController{
    
    func registerForKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
            
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
