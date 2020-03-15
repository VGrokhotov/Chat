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
    @IBOutlet weak var operationButton: UIButton!
    @IBOutlet weak var GCDButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Vars and Lets
    
    var operationDataManager: OperationDataManager?
    var gcdDataManager: GCDDataManager?
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
    
    
    @IBAction func operationButtonPressed(_ sender: Any) {
        
        willSwitchToViewMode()
        operationDataManager?.saveAndShowData(
            name: nameTextField.text,
            description: descriptionTextView.text,
            image: profileImageView.image
        )
        
    }
    
    @IBAction func GCDButtonPressed(_ sender: Any) {
        
        willSwitchToViewMode()
        gcdDataManager?.saveAndShowData(
            name: nameTextField.text,
            description: descriptionTextView.text,
            image: profileImageView.image
        )
        
    }
    
    //MARK: Satic func
    
    static func makeVC() -> ProfileViewController {
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ProfileViewController.self)) as? ProfileViewController
        
        guard let newVC = newViewController else {return ProfileViewController()}

        return newVC
    }
    
    //MARK: Alert controllers
    
    func showAlert(title: String, message: String){
        activityIndicator.stopAnimating()
        let allert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        allert.addAction(okAction)
        present(allert, animated: true)
    }
    
    
    //MARK: View DidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gcdDataManager = GCDDataManager(profileVC: self)
        operationDataManager = OperationDataManager(profileVC: self)
        
        profileImageView.contentMode = .scaleAspectFill
        
        activityIndicator.startAnimating()

        gcdDataManager?.readData(isSaving: false)
        
        setupToHideKeyboardOnTapOnView()
        
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        registerForKeyboardNotification()
        
        editButton.layer.cornerRadius = 10
        editButton.layer.borderWidth = 2.0
        editButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        editButton.clipsToBounds = true
        
        GCDButton.layer.cornerRadius = 10
        GCDButton.layer.borderWidth = 2.0
        GCDButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        GCDButton.clipsToBounds = true
        
        operationButton.layer.cornerRadius = 10
        operationButton.layer.borderWidth = 2.0
        operationButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        operationButton.clipsToBounds = true

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
        operationButton.isEnabled = true
        GCDButton.isEnabled = true
        choosePhotoButton.isEnabled = true
    }
    
    func disableButtons(){
        operationButton.isEnabled = false
        GCDButton.isEnabled = false
        choosePhotoButton.isEnabled = false
    }
    
    func disableSaveButtons(){
        operationButton.isEnabled = false
        GCDButton.isEnabled = false
    }
    
    func switchToEditting() {
        nameTextField.text = nameLabel.text
        descriptionTextView.text = descriptionLabel.text
        
        enableButtons()
        
        hide(view: nameLabel)
        hide(view: descriptionLabel)
        hide(view: editButton)
        
        show(view: choosePhotoButton)
        show(view: nameTextField)
        show(view: descriptionTextView)
        show(view: operationButton)
        show(view: GCDButton)
    }
    
    func willSwitchToViewMode() {
        disableButtons()
        activityIndicator.startAnimating()
    }
    
    func didSwitchToViewMode(name: String?, description: String?, image: UIImage?, isSaving: Bool){
        
        profileImageView.image = image
        nameLabel.text = name
        descriptionLabel.text = description
        
        activityIndicator.stopAnimating()
        
        if isSaving {
        
            show(view: nameLabel)
            show(view: descriptionLabel)
            show(view: editButton)
            
            hide(view: choosePhotoButton)
            hide(view: nameTextField)
            hide(view: descriptionTextView)
            hide(view: operationButton)
            hide(view: GCDButton)
        
        
            showAlert(title: "Successfully saved!", message: "All information changed successfully")
        }
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
        
    }
}

//MARK: - Text View delegate

extension ProfileViewController: UITextViewDelegate{
    
    @objc private func textViewChanged(){
        if nameTextField.text?.count == 0{
            disableSaveButtons()
        } else {
            enableButtons()
        }
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
