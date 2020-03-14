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
        saveName(name: name)
        saveDescription(description: description)
        saveImage(image: image)
    }
    
    func saveName(name: String?){
        let nameFile = "name.txt"

        guard let name = name else {return}

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(nameFile)
            

            do {
                try name.write(to: fileURL, atomically: false, encoding: .utf8)
                
            }
            catch {
                DispatchQueue.main.async {
                    //self.showAlertWithRetry(title: "Saving failed", message: "Could not sava data")
                }
            }
 

        }
    }
    
    func saveDescription(description: String?){
        let descriptionFile = "description.txt"

        guard let description = description else {return}

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(descriptionFile)

            do {
                try description.write(to: fileURL, atomically: false, encoding: .utf8)
            
            }
            catch {
                DispatchQueue.main.async {
                    //self.showAlertWithRetry(title: "Saving failed", message: "Could not sava data")
                }
            }
        }
    }
    
    func saveImage(image: UIImage?){
        let imageFile = "image.png"

        guard let image = image?.pngData() else {return}
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(imageFile)

            do {
                try image.write(to: fileURL, options: .atomic)
            }
            catch {
                DispatchQueue.main.async {
                    //self.showAlertWithRetry(title: "Saving failed", message: "Could not sava data", )
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
