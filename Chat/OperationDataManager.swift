//
//  OperationDataManager.swift
//  Chat
//
//  Created by Владислав on 14.03.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class OperationDataManager{
    
    class SaveNameOperation: AsyncOperation{
        
        weak var operationDataManager: OperationDataManager?
        
        var profileName: String?
        
        init(name: String?, dataManager: OperationDataManager) {
            self.profileName = name
            self.operationDataManager = dataManager
            super.init()
        }
        
        override func main() {
            if let profileName = profileName{
                operationDataManager?.saveName(name: profileName) {
                    self.state = .finished
                    self.operationDataManager?.savesDone += 1
                }
            }
        }
    }
    
    class SaveDescriptionOperation: AsyncOperation{
        
        weak var operationDataManager: OperationDataManager?
        
        var profileDescription: String?
        
        init(description: String?, dataManager: OperationDataManager) {
            self.profileDescription = description
            self.operationDataManager = dataManager
            super.init()
        }
        
        override func main() {
            if let description = profileDescription{
                operationDataManager?.saveDescription(description: description) {
                    self.state = .finished
                    self.operationDataManager?.savesDone += 1
                }
            }
        }
    }
    
    class SaveImageOperation: AsyncOperation{
        
        weak var operationDataManager: OperationDataManager?
        
        var profileImage: UIImage?
        
        init(image: UIImage?, dataManager: OperationDataManager) {
            self.profileImage = image
            self.operationDataManager = dataManager
            super.init()
        }
        
        override func main() {
            if let image = profileImage{
                operationDataManager?.saveImage(image: image) {
                    self.state = .finished
                    self.operationDataManager?.savesDone += 1
                }
            }
        }
    }
    
    class ReadNameOperation: AsyncOperation{
        
        weak var operationDataManager: OperationDataManager?
        
        var profileName: String?
        
        init(dataManager: OperationDataManager) {
            self.operationDataManager = dataManager
            super.init()
        }
        
        override func main() {
            operationDataManager?.readName(comletion: { name in
                self.state = .finished
                self.profileName = name
                self.operationDataManager?.readsDone += 1
            })
        }
    }
    
    class ReadDescriptionOperation: AsyncOperation{
        
        weak var operationDataManager: OperationDataManager?
        
        var profileDescription: String?
        
        init(dataManager: OperationDataManager) {
            self.operationDataManager = dataManager
            super.init()
        }
        
        override func main() {
            operationDataManager?.readDescription(comletion: { description in
                self.state = .finished
                self.profileDescription = description
                self.operationDataManager?.readsDone += 1
            }) 
                
        }
    }
    
    class ReadImageOperation: AsyncOperation{
        
        weak var operationDataManager: OperationDataManager?
        
        var profileImage: UIImage?
        
        init( dataManager: OperationDataManager) {
            self.operationDataManager = dataManager
            super.init()
        }
        
        override func main() {
            operationDataManager?.readImage(comletion: { image in
                self.state = .finished
                self.profileImage = image
                self.operationDataManager?.readsDone += 1
            })
        }
    }
    
    
    var saveNameOperatiom: SaveNameOperation?
    var saveDescriptionOperation: SaveDescriptionOperation?
    var saveImageOperation: SaveImageOperation?
    
    
    
    var amountOfSaves = 0
    
    var successfullySaved = true {
        didSet{
            if successfullySaved == false {
                let queue = OperationQueue.main
                queue.addOperation({
                    self.profileVC?.showOperationAlertWithRetry(
                        title: "Saving failed",
                        message: "Could not sava data",
                        name: self.saveNameOperatiom?.profileName,
                        description: self.saveDescriptionOperation?.profileDescription,
                        image: self.saveImageOperation?.profileImage)
                })
            }
            successfullySaved = true
            savesDone = 0
            amountOfSaves = 0
        }
    }
    var savesDone = 0 {
        didSet{
            if savesDone == amountOfSaves{
                
                if successfullySaved {
                    let queue = OperationQueue.main
                    queue.addOperation({
                        self.profileVC?.showOperationSuccessAlert(title: "Successfully saved!", message: "All information changed successfully")
                    })
                        
                }
                savesDone = 0
                amountOfSaves = 0
            }
        }
    }
    
    var readNameOperation: ReadNameOperation?
    var readDescriptionOperation: ReadDescriptionOperation?
    var readImageOperation: ReadImageOperation?
    var isSaving = false

    var amountOfReads = 0
    
    var readsDone = 0{
        didSet {
            if readsDone == amountOfReads{
                let queue = OperationQueue.main
                queue.addOperation({
                    self.profileVC?.didSwitchToViewMode(
                        name: self.readNameOperation?.profileName,
                        description: self.readDescriptionOperation?.profileDescription,
                        image: self.readImageOperation?.profileImage,
                        isSaving: self.isSaving)
                })
                

                readsDone = 0
                amountOfReads = 0
            }
            
        }
    }
    
    weak var profileVC: ProfileViewController?
    
    init(profileVC: ProfileViewController) {
        self.profileVC = profileVC
    }
    
    func saveAndShowData(name: String?, description: String?, image: UIImage?){
        
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInteractive
        
        if profileVC?.hasNameChanged ?? true {
            saveNameOperatiom = SaveNameOperation(name: name, dataManager: self)
            saveNameOperatiom?.qualityOfService = .userInteractive
            amountOfSaves += 1
            if  let saveNameOperatiom = saveNameOperatiom {
                operationQueue.addOperation(saveNameOperatiom)
            } else {
                successfullySaved = false
            }
        }
        
        if profileVC?.hasDescriptionChanged ?? true{
            saveDescriptionOperation = SaveDescriptionOperation(description: description, dataManager: self)
            saveDescriptionOperation?.qualityOfService = .userInteractive
            amountOfSaves += 1
            if let saveDescriptionOperation = saveDescriptionOperation{
                operationQueue.addOperation(saveDescriptionOperation)
            } else {
                successfullySaved = false
            }
        }
        if profileVC?.hasImageChanged ?? true{
            saveImageOperation = SaveImageOperation(image: image, dataManager: self)
            saveImageOperation?.qualityOfService = .userInteractive
            amountOfSaves += 1
            if let saveImageOperation = saveImageOperation {
                operationQueue.addOperation(saveImageOperation)
            }  else {
                successfullySaved = false
            }
        }
        
    }
    
    func readData( isSaving: Bool) {
        
        self.isSaving = isSaving

        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInteractive
        
        readNameOperation = ReadNameOperation(dataManager: self)
        readNameOperation?.qualityOfService = .userInteractive
        amountOfReads += 1
        
        readDescriptionOperation = ReadDescriptionOperation(dataManager: self)
        readDescriptionOperation?.qualityOfService = .userInteractive
        amountOfReads += 1
        
        readImageOperation = ReadImageOperation(dataManager: self)
        readNameOperation?.qualityOfService = .userInteractive
        amountOfReads += 1
        
        guard
            let readImageOperation = readImageOperation,
            let readDescriptionOperation = readDescriptionOperation,
            let readNameOperation = readNameOperation
            else {return}
        
        operationQueue.addOperation(readImageOperation)
        operationQueue.addOperation(readDescriptionOperation)
        operationQueue.addOperation(readNameOperation)

    }
    
    
    func saveName(name: String?, comletion: @escaping (() -> ()) ){
        let nameFile = "name.txt"
        
        guard let name = name else {return}
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(nameFile)
            
            do {
                try name.write(to: fileURL, atomically: false, encoding: .utf8)
                comletion()
            }
            catch {
                successfullySaved = false
            }
        }else{
            successfullySaved = false
        }
    }
    
    func saveDescription(description: String?, comletion: @escaping (() -> ()) ){
        let descriptionFile = "description.txt"
        
        guard let description = description else {return}
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(descriptionFile)
            
            do {
                try description.write(to: fileURL, atomically: false, encoding: .utf8)
                comletion()
            }
            catch {
                successfullySaved = false
            }
            
            
        } else{
            successfullySaved = false
        }
    }
    
    func saveImage(image: UIImage?, comletion: @escaping (() -> ()) ){
        let imageFile = "image.png"
        
        guard let image = image?.pngData() else {return}
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(imageFile)
            
            do {
//                enum MyError: Error {
//                    case runtimeError(String)
//                }
//                throw MyError.runtimeError("l")
                
                try image.write(to: fileURL, options: .atomic)
                comletion()
            }
            catch {
                successfullySaved = false
            }
            
        }else{
            successfullySaved = false
        }
        
    }
    
    
    func readName(comletion: @escaping ((String?) -> ()) ) {
        let nameFile = "name.txt"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(nameFile)
            
            do {
                let name = try String(contentsOf: fileURL, encoding: .utf8)
                comletion(name)
            }
            catch {
                comletion("Default")
            }
            
        } else{
            comletion("Default")
        }
        
    }
    
    func readDescription(comletion: @escaping ((String?) -> ()) ) {
        let descriptionFile = "description.txt"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(descriptionFile)
            
            do {
                let name = try String(contentsOf: fileURL, encoding: .utf8)
                comletion(name)
            }
            catch {
                comletion("Default")
            }
            
        } else{
            comletion("Default")
        }
        
    }
    
    
    func readImage(comletion: @escaping ((UIImage?) -> ())) {
        let imageFile = "image.png"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(imageFile)
            
            do {
                let data = try Data.init(contentsOf: fileURL)
                if let image = UIImage(data: data){
                    comletion(image)
                } else{
                    comletion(#imageLiteral(resourceName: "placeholder-user"))
                }
                
            }
            catch {
                comletion(#imageLiteral(resourceName: "placeholder-user"))
            }
            
            
        } else{
            comletion(#imageLiteral(resourceName: "placeholder-user"))
        }
        
    }
}



class AsyncOperation: Operation {
    
    // Определяем перечисление enum State со свойством keyPath
    enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    // Помещаем в subclass свойство state типа State
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

extension AsyncOperation {
    // Переопределения для Operation
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
        state = .executing
    }
    
    override func cancel() {
        state = .finished
    }
    
}
