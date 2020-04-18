//
//  Images.swift
//  Chat
//
//  Created by Владислав on 17.04.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

protocol ImageStorage {
    func getImages(errorCompletion: @escaping (String) -> (), completion: @escaping ([String]) -> ())
    func getImage(from: String, errorCompletion: @escaping () -> (), completion: @escaping (Data) -> ())
}

class Images: ImageStorage {
    
    func getImages(errorCompletion: @escaping (String) -> (), completion: @escaping ([String]) -> ()) {
        
        let token = "16097354-2cd410dd36b8e372de7e58695"
        let session = URLSession.shared
        let url = URL(string: "https://pixabay.com/api/?key=\(token)&q=flowers&per_page=200&image_type=photo&pretty=true")
        
        if let url = url {
            
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    DispatchQueue.main.async {
                        errorCompletion(error.localizedDescription)
                    }
                } else if let data = data {
                    //достать largeImageURL
                    let response = try? JSONDecoder().decode(Hits.self, from: data)
                    
                    if let response = response {
                        
                        var imageURLs = [String]()
                        
                        for item in response.hits {
                            imageURLs.append(item.largeImageURL)
                        }
                        
                        DispatchQueue.main.async {
                            completion(imageURLs)
                        }
                    }
                }
            }
            task.resume()
        } else {
            DispatchQueue.main.async {
                errorCompletion("Wrong URL of images source, sorry")
            }
        }
    }
    
    func getImage(from: String, errorCompletion: @escaping () -> (), completion: @escaping (Data) -> ())  {
        
        let session = URLSession.shared
        
        let url = URL(string: from)
        
        if let url = url {
            
            let request = URLRequest(url: url)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if let _ = error {
                    DispatchQueue.main.async {
                        errorCompletion()
                    }
                } else if let data = data {
                    
                    DispatchQueue.main.async {
                        completion(data)
                    }
                }
            }
            
            task.resume()
        } else {
            DispatchQueue.main.async {
                errorCompletion()
            }
        }

    }
}

struct Hits {
    let hits: [ImageURL]
    
    enum CodingKeys: String, CodingKey {
        case hits
    }
    
}

extension Hits: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.hits = try values.decode([ImageURL].self, forKey: .hits)
    }
}

struct ImageURL {
    let largeImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case largeImageURL
    }
}

extension ImageURL: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.largeImageURL = try values.decode(String.self, forKey: .largeImageURL)
    }
}
