import UIKit

class CEO {
    
    weak var manager: ProductManager?
    
    var name: String = ""
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("CEO \(name) is deinited")
    }
    
    lazy var ToString: () -> String = {
        return "CEO: \(self.name)\n"
    }
    
    lazy var printCompany: () -> Void = { [weak self] in
        
        if let manager = self?.manager {
            manager.printCompany()
        } else {
            print("Can not print Company: there is no Product Manager\n")
        }
    }
    
    lazy var printDevelopers: () -> Void = { [weak self] in
        
        if let manager = self?.manager {
            
            print("Printing Developers\n")
            manager.printDevelopers()
            
        } else {
            print("Can not print Developers: there is no Product Manager\n")
        }
    }
    
    lazy var printProductManager: () -> Void = { [weak self] in
        
        if let manager = self?.manager {
            
            print("Printing Product Manager\n")
            print(manager.ToString())
            print()
            
        } else {
            print("Can not print Product Manager: there is no Product Manager\n")
        }
    }
    
    
}

class ProductManager {
    
    weak var ceo: CEO?
    
    var developers: [Developer] = []
    
    var name: String = ""
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("Product Manager \(name) is deinited")
    }
    
    func printMassage(message: String){
        print(message)
    }
    
    func ToString() -> String {
        return "Product Manager: \(name)\n"
    }
    
    func printCompany() -> Void {
        
        print("Printing company\n")
        
        if let ceo = self.ceo {
            print(ceo.ToString())
        } else {
            print("Can not print CEO: there is no CEO\n")
        }
        
        print(self.ToString())
        
        print("Developers")
        
        self.printDevelopers()
        
    }
    
    func printDevelopers() -> Void {
        
        if self.developers.count > 0 {
            for developer in self.developers{
                print(developer.ToString())
            }
        } else {
            print("No developers")
        }
        
        print("\n")
    }
    
}

class Developer {
    
    weak var manager: ProductManager?
    
    var name: String = ""
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("Developer \(name) is deinited")
    }
    
    func sendMessageToCEO(message: String){
        
        if let manager = self.manager {
            
            if let _ = manager.ceo{
                manager.printMassage(message: "Message to CEO\n\(message)\nFrom \(self.ToString())\n")
            } else {
                print("Can not send message to CEO: there is no CEO\n")
            }
            
        } else {
            print("Can not send message to CEO: there is no Product manager\n")
        }
    }
    
    func askProductManager(with message: String){
        
        if let manager = self.manager {
            manager.printMassage(message: "Message to Product Manager\n\(message)\nFrom \(self.ToString())\n")
        } else {
            print("Can not ask Product Manager: there is no Product manager\n")
        }
    }
    
    func sendMessageToDeveloper(message: String, index indexOfAvalibleDevelopers: Int){
        
        if let manager = self.manager {
            
            var availableDevelopers: [Developer] = []
            
            for developer in manager.developers{
                if developer !== self {
                    availableDevelopers.append(developer)
                }
            }
            
            if availableDevelopers.count > 0{
                // Я хотел сделать тут запрос индекса с выводом возможных девелоперов, но playground не может в консоль :(
                // Поэтому этот индекс задается в вызове функции
                if indexOfAvalibleDevelopers < availableDevelopers.count && indexOfAvalibleDevelopers >= 0 {
                    let chosenDeveloper = availableDevelopers[indexOfAvalibleDevelopers].ToString()
                    manager.printMassage(message: "Message to \(chosenDeveloper)\n\(message)\nFrom \(self.ToString())\n")
                } else {
                    print("Can not send message to another Developer: Incorrect index of Developer\n")
                }
                
            } else {
                print("Can not send message to another Developer: There is no another Developer\n")
            }
            
        } else {
            print("Can not send message to another Developer: there is no Product manager\n")
        }
        
    }
    
    func ToString() -> String {
        return "Developer: \(name)"
    }
}

class Company{
    
    var name: String
    
    var ceo: CEO
    
    var manager: ProductManager
    
    var developers: [Developer] = []
    
    init(name: String, _ ceo: CEO, _ manager: ProductManager, _ developers: [Developer]){
        
        self.name = name
        self.ceo = ceo
        self.manager = manager
        self.developers = developers
        
        self.ceo.manager = self.manager
        self.manager.ceo = self.ceo

        for developer in self.developers{
            developer.manager = self.manager
        }
        
        self.manager.developers = developers
        
    }
    
    deinit {
        print("Company \(name) is deinited")
    }
}

func getCompany() -> Company {
    return Company(name: "My Company", CEO(name: "Alex"), ProductManager(name: "Sasha"), [Developer(name: "Vlad"), Developer(name: "Ivan")])
}

var company: Company? = getCompany()

company?.ceo.printCompany()

company?.ceo.printDevelopers()

company?.ceo.printProductManager()

company?.developers[0].sendMessageToCEO(message: "I wanna my salary be bigger")

company?.developers[1].sendMessageToCEO(message: "I wanna my salary be bigger too")

company?.developers[0].askProductManager(with: "Give me task, pls")
company?.developers[1].askProductManager(with: "Give me task, pls, too")

company?.developers[1].sendMessageToDeveloper(message: "I sent you a pull-request", index:  0) ///зачем здесь 0? смотрите комментарий в Definition
company?.developers[0].sendMessageToDeveloper(message: "Your code is terrible", index:  0) ///зачем здесь 0? смотрите комментарий в Definition



company = nil

