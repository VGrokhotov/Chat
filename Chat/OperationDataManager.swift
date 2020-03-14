//
//  OperationDataManager.swift
//  Chat
//
//  Created by Владислав on 14.03.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class OperationDataManager{
    
    class SaveOperation: Operation{
        
    }
    
    weak var profileVC: ProfileViewController?
    
    init(profileVC: ProfileViewController) {
        self.profileVC = profileVC
    }
    
    func saveAndShowData(name: String?, description: String?, image: UIImage?){
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 3
        
            self.saveData(
                name: name,
                description: description,
                image: image)
            
            self.readData(isSaving: true)
        
    }
    
    func readData( isSaving: Bool) {

            
            let image = self.readImage()
            let name = self.readName()
            let description = self.readDescription()
            

                self.profileVC?.didSwitchToViewMode(
                    name: name,
                    description: description,
                    image: image,
                    isSaving: isSaving)

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
            catch {}
            
            
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
            catch {}
            
            
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
            catch {}
            
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
}
