//
//  PhotoEditor+Keyboard.swift
//  Pods
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit

extension PhotoEditorViewController {
    
    @objc func keyboardDidShow(notification: NSNotification) {
        if isTyping {
            doneButton.isHidden = false
            cancelButton.isHidden = false
            colorPickerView.isHidden = false
            hideToolbar(hide: true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        isTyping = false
        doneButton.isHidden = true
        cancelButton.isHidden = true
        hideToolbar(hide: false)
    }
    
    @objc func keyboardWillChangeFrame(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            guard let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                       return
            }
            guard let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else  {
                return
            }
            
            guard let animationCurveRawNSN = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber) else {
                return
            }
            
            // let endFrame = (userInfo[UIResponder.UIKeyboardFrameEndUserInfoKey] as? NSValue).CGRectValue()
            //let duration:TimeInterval = (userInfo[UIResponder.UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            //if let animationCurveRawNSN = userInfo[UIResponder.] as? NSNumber {}
            
            let animationCurveRaw = animationCurveRawNSN.uintValue 
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame.origin.y) >= UIScreen.main.bounds.size.height {
                self.colorPickerViewBottomConstraint?.constant = 0.0
            } else {
                self.colorPickerViewBottomConstraint?.constant = endFrame.size.height 
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

}
