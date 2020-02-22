//
//  ViewController.swift
//  Chat
//
//  Created by Владислав on 16.02.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //print("EditButton frame : \(editButton.frame) from \(#function)")
        //Can not refer to editButton IBOutlet because it is nil: button has not been added to View Controller yet
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    // MARK: - Vars and Lets
    
    var presentViewControllerLifecycleLogs = false

    // MARK: - IBActions
    
    @IBAction func choosePhotoButtonAction(_ sender: Any) {
        print("Выбери изображение профиля")
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
    
    @IBAction func editButtonPressed(_ sender: Any) {
        print("Редактирование профиля")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        choosePhotoButton.layer.cornerRadius = choosePhotoButton.imageView!.frame.size.height / 2
        choosePhotoButton.imageView?.contentMode = .scaleAspectFit
        choosePhotoButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        choosePhotoButton.clipsToBounds = true
        
        profileImageView.layer.cornerRadius = choosePhotoButton.layer.cornerRadius
        
        editButton.layer.cornerRadius = 10
        editButton.layer.borderWidth = 2.0
        editButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        editButton.clipsToBounds = true
        
        print("EditButton frame : \(editButton.frame) from \(#function)")
        
        if presentViewControllerLifecycleLogs{
            print("View controller's view was loaded into memory. Function: \(#function)\n")
            
        }
    }
    
    // MARK: ViewController Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if presentViewControllerLifecycleLogs{
            print("View controller's view is about to be added to a view hierarchy. Function: \(#function)\n")
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("EditButton frame : \(editButton.frame) from \(#function)")
        //Frame has changed because at viewDidLoad function subviews are not laid out. Before viewDidAppear all subviews become laid out and origin of frame changes.
        if presentViewControllerLifecycleLogs{
            print("View controller's view was added to a view hierarchy. Function: \(#function)\n")
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if presentViewControllerLifecycleLogs{
            print("View controller's view is about to layout its subviews. Function: \(#function)\n")
            
        }
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if presentViewControllerLifecycleLogs{
            print("View controller's view has just laid out its subviews. Function: \(#function)\n")
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if presentViewControllerLifecycleLogs{
            print("View controller's view is about to be removed from a view hierarchy. Function: \(#function)\n")
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if presentViewControllerLifecycleLogs{
            print("View controller's view was removed from a view hierarchy. Function: \(#function)\n")
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
}
