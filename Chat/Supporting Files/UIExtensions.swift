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

extension UIWindow {
    
    private struct TouchInfo {
        static var timer = Timer()
        static var picturesInterval: Double = 0.1
        static var touchLocation: CGPoint = CGPoint()
    }
    
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        touches.forEach { (touch) in
            
            TouchInfo.touchLocation = touch.location(in: self)
            startTimer()
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { (touch) in
            TouchInfo.touchLocation = touch.location(in: self)
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        stopTimer()
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        stopTimer()
    }

    func startTimer() {
        TouchInfo.timer = Timer.scheduledTimer(
            timeInterval: 0.2,
            target: self,
            selector: #selector(createPicture),
            userInfo: nil,
            repeats: true)
    }

    func stopTimer() {
        TouchInfo.timer.invalidate()
        TouchInfo.timer = Timer()
    }
    
    @objc func createPicture() {
        let location = TouchInfo.touchLocation
        
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            imageView.removeFromSuperview()
        }
        
        UIView.animateKeyframes(
            withDuration: 0.5,
            delay: 0,
            animations: {
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.5) {
                        imageView.center = CGPoint(
                            x: location.x + deltaX,
                            y: location.y + deltaY)
                }
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0.3,
                    relativeDuration: 0.49) {
                        imageView.alpha = 0
                }
                
        }, completion: nil)
    }
}
