//
//  ViewControllerExtension.swift
//  Chat
//
//  Created by Владислав on 26.04.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

//MARK: To dismiss keyboard after tapping anywhere else

extension UIViewController {
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: Work with touches

extension UIView {
    
    private struct TouchInfo {
        static var flag: Bool = false
        static var updateTime: Double = 0
        static var picturesInterval: Double = 0.1
    }
    
    
    private var isTouching: Bool {
        get {
            return TouchInfo.flag
        }
        set(newValue) {
            TouchInfo.flag = newValue
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        isTouching = true
        createPicturesWhileTouching(touches: touches)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isTouching = false
    }
    
    func createPicturesWhileTouching(touches: Set<UITouch>){
        touches.forEach { (touch) in
            
            while(isTouching) {
                let currentTime = Date().timeIntervalSince1970
                if TouchInfo.updateTime == 0 {
                    TouchInfo.updateTime = currentTime
                }

                if currentTime - TouchInfo.updateTime > TouchInfo.picturesInterval {
                    createPicture(touch: touch)
                    TouchInfo.updateTime = currentTime
                }
            }
        }
    }
    
    func createPicture(touch: UITouch) {
        let location = touch.location(in: self)
        
        let imageView = UIImageView(frame: CGRect(x: location.x, y: location.y, width: 20, height: 20))
        //imageView.center = location
        imageView.image = #imageLiteral(resourceName: "tinkoff")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.backgroundColor = .clear
        
        self.addSubview(imageView)
        
        let angle = CGFloat.random(in: 0..<360)
        let deltaX = 50 * cos(angle * CGFloat.pi / 180)
        let deltaY = 50 * sin(angle * CGFloat.pi / 180)
        
        UIView.animateKeyframes(
            withDuration: 0.3,
            delay: 0,
            animations: {
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.3) {
                        imageView.center = CGPoint(
                            x: touch.location(in: self).x + deltaX,
                            y: touch.location(in: self).y + deltaY)
                }
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0.1,
                    relativeDuration: 0.29) {
                        imageView.alpha = 0
                }
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0.29,
                    relativeDuration: 0.3) {
                        imageView.removeFromSuperview()
                }
                
        }, completion: nil)
    }
}
