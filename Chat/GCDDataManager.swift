//
//  GCDDataManager.swift
//  Chat
//
//  Created by Владислав on 14.03.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class GCDDataManager{
    
    weak var profileVC: ProfileViewController?
    
    init(profileVC: ProfileViewController) {
        self.profileVC = profileVC
    }
    
    func saveAndShowData(name: String?, description: String?, image: UIImage?){
        let queue = DispatchQueue( label:"com.app.queue", qos: .userInteractive, attributes:.concurrent)
        
        queue.async {
        
            self.saveData(
                name: name,
                description: description,
                image: image)
            
        }
    }
    
    func readData(isSaving: Bool) {
        let queue = DispatchQueue( label:"com.app.queue", qos: .userInteractive, attributes:.concurrent)
        queue.async {
            
            let image = self.readImage()
            let name = self.readName()
            let description = self.readDescription()
            
            DispatchQueue.main.async {
                self.profileVC?.didSwitchToViewMode(
                    name: name,
                    description: description,
                    image: image,
                    isSaving: isSaving
                )
            }
        }
    }
    
    func saveData(name: String?, description: String?, image: UIImage?){
        let nameFile = "name.txt"
        
        guard let name = name else {return}
        
        let descriptionFile = "description.txt"

        guard let description = description else {return}
        
        let imageFile = "image.png"

        guard let imageData = image?.pngData() else {return}
        
        
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let nameURL = dir.appendingPathComponent(nameFile)

            let descriptionURL = dir.appendingPathComponent(descriptionFile)
            
            let imageURL = dir.appendingPathComponent(imageFile)
            
            let queue = DispatchQueue( label:"com.app.queue", qos: .userInteractive, attributes:.concurrent)
            queue.async {
                do {
                    
                    try name.write(to: nameURL, atomically: false, encoding: .utf8)
                    try description.write(to: descriptionURL, atomically: false, encoding: .utf8)
                    try imageData.write(to: imageURL, options: .atomic)
                    
//                    enum MyError: Error {
//                        case runtimeError(String)
//                    }
//                    throw MyError.runtimeError("l")
                    
                    queue.async {
                        
                        let image = self.readImage()
                        let name = self.readName()
                        let description = self.readDescription()
                        
                        DispatchQueue.main.async {
                            self.profileVC?.didSwitchToViewMode(
                                name: name,
                                description: description,
                                image: image,
                                isSaving: true
                            )
                        }
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        self.showAlertWithRetry(
                            title: "Saving failed",
                            message: "Could not sava data",
                            name: name,
                            description: description,
                            image: image)
                    }
                    
                }
                
                
            }
            
            
        }
    }
    

    
    func readName() -> String {
        let nameFile = "name.txt"

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(nameFile)

            do {
                let name = try String(contentsOf: fileURL, encoding: .utf8)
                return name
            }
            catch {
                return "Default"
            }
            
        } else{
            return "Default"
        }
        
    }
    
    func readDescription() -> String {
        let descriptionFile = "description.txt"

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(descriptionFile)

            do {
                let name = try String(contentsOf: fileURL, encoding: .utf8)
                return name
            }
            catch {
                return "Default"
            }
            
        } else{
            return "Default"
        }
        
    }
    
    
    func readImage() -> UIImage{
        let imageFile = "image.png"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(imageFile)
            
            do {
                let data = try Data.init(contentsOf: fileURL)
                if let image = UIImage(data: data){
                    return image
                } else{
                    return #imageLiteral(resourceName: "placeholder-user")
                }
                
            }
            catch {
                return #imageLiteral(resourceName: "placeholder-user")
            }
            

        } else{
            return #imageLiteral(resourceName: "placeholder-user")
        }
        
    }
    
    func showAlertWithRetry(title: String, message: String, name: String?, description: String?, image: UIImage?){
        profileVC?.activityIndicator.stopAnimating()
        profileVC?.enableButtons()
        let allert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            self.saveData(name: name, description: description, image: image)
        }
        
        allert.addAction(okAction)
        allert.addAction(retryAction)
        profileVC?.present(allert, animated: true)
    }
}
