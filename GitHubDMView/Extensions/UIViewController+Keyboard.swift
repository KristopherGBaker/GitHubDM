//
//  UIViewController+Keyboard.swift
//  GitHubDMView
//
//  Created by Kris Baker on 9/8/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import UIKit

/// The KeyboardObserving protocol is adopted by view controller's
/// that observe keyboard changes.
internal protocol KeyboardObserving {

    /// Tells the view controller the keyboard changed.
    /// - Parameters:
    ///     - height: The keyboard height.
    ///     - animationCurve: The animation curve for the change.
    ///     - duration: The animation duration.
    func keyboardChanged(to height: CGFloat,
                         with animationCurve: UIView.AnimationOptions,
                         duration: TimeInterval)

}

internal extension UIViewController {
    
    /// Starts observing keyboard changes.
    /// If using this, make sure to call `NotificationCenter.default.removeObserver(self)`
    /// in deinit.
    func observeKeyboardChanges() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    /// Called when keyboard changes are observed.
    /// If the view controller adopts the `KeyboardObserving` protocol,
    /// the keyboardChanged method will be called with the keyboard changes.
    @objc func keyboardWillChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let observer = self as? KeyboardObserving else {
            return
        }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.minY ?? 0
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNumber = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNumber?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        let height = endFrameY >= UIScreen.main.bounds.height ? 0 : endFrame?.height ?? 0
        observer.keyboardChanged(to: height, with: animationCurve, duration: duration)
    }
    
}
