//
//  ProfileService.swift
//  Chat
//
//  Created by Владислав on 15.04.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class ProfileService {
    
    private var storageManager: ProfileDataManager = ProfileStorageManager()
    
    func saveData(
        name: String?,
        description: String?,
        imageData: Data?,
        hasNameChanged: Bool,
        hasDescriptionChanged: Bool,
        hasImageChanged: Bool,
        complition: @escaping (Bool) -> () ) {
        
        storageManager.saveData(
            name: name,
            description: description,
            imageData: imageData,
            hasNameChanged: hasNameChanged,
            hasDescriptionChanged: hasDescriptionChanged,
            hasImageChanged: hasImageChanged,
            complition: complition)
    }
    
    func readData() -> [Any?] {
        return storageManager.readData()
    }
    
}
