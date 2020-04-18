//
//  ImagesService.swift
//  Chat
//
//  Created by Владислав on 17.04.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class ImagesService {
    
    private var imageStorage: ImageStorage = Images()
    
    func getImages(errorCompletion: @escaping (String) -> (), completion: @escaping ([String]) -> ()) {
        imageStorage.getImages(errorCompletion: errorCompletion, completion: completion)
    }
    
    func getImage(from: String, errorCompletion: @escaping () -> (), completion: @escaping (Data) -> ())  {
        imageStorage.getImage(from: from, errorCompletion: errorCompletion, completion: completion)
    }
}
