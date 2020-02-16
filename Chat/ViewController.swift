//
//  ViewController.swift
//  Chat
//
//  Created by Владислав on 16.02.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var presentViewControllerLifecycleLogs = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

