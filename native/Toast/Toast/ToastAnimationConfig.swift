//
//  ToastAnimationConfig.swift
//
//  Created by Rakesha Shastri on 10/01/18.
//

import Foundation
import UIKit

public class ToastAnimationConfig {
    
    var toast: ToastView!
    
    //MARK: - DIRECTION VARIABLES
    public var entryDirection: ToastDirection = .up
    public var exitDirection: ToastDirection = .down
    public var position: ToastPosition = .bottom
    public var persist: Bool = true
    
    //MARK: - DISTANCE VARIABLES
    public var animateDistance: CGFloat! = 100
    public var wobbleAnimateDistance: CGFloat! = 3
    
    //MARK: - TIME VARIABLES
    public var animateDuration: TimeInterval = 0.25
    public var wobbleDuration: TimeInterval = 0.25
    public var displayDuration: TimeInterval = 2
    public var labelTitleAnimateDuration: TimeInterval = 2
    public var labelTitleFadeDuration: TimeInterval = 0.15
    
    //MARK: - TIMERS
    var exitDelayTimer: CountdownTimer!
    var labelAnimateTimer: Timer!
    
    //MARK: - ANCHORS
    var xAnchorConstraint: NSLayoutConstraint!
    var yAnchorConstraint: NSLayoutConstraint!
    var heightAnchorConstraint: NSLayoutConstraint!
    var widthAnchorConstraint: NSLayoutConstraint!
    
    //MARK: - VISIBILITY VARIABLES
    public var alpha: CGFloat = 1
    
    public convenience init(animateDuration: TimeInterval, displayDuration: TimeInterval, distance: CGFloat, wobbleDistance: CGFloat?, alpha: CGFloat?) {
        self.init()
        
        self.animateDuration = animateDuration
        self.displayDuration = displayDuration
        self.animateDistance = distance
        if let wobbleDistanceFound = wobbleDistance {
            self.wobbleAnimateDistance = wobbleDistanceFound
        }
        if let alphaFound = alpha {
            self.alpha = alphaFound
        }
    }
    
    //MARK: - ANIMATION METHOD
    public func action(action: ToastAction, delay: TimeInterval = 0, completion: @escaping (Bool) -> Void = { _ in }) {
//        debugPrint(action)
        let constraint: NSLayoutConstraint!
        var totalDistance: CGFloat!
        let direction: ToastDirection!
        var firstLegAnimationDuration: TimeInterval!
        var secondLegAnimationDuration: TimeInterval!
        
//        if persist == true {
//            let timer = Timer(
//        }
        
        // You gotta handle animation properly for both entry and exit right?
        switch action {
        case .entry:
            direction = entryDirection
            firstLegAnimationDuration = animateDuration
            secondLegAnimationDuration = wobbleDuration
        case .exit:
            direction = exitDirection
            firstLegAnimationDuration = wobbleDuration
            secondLegAnimationDuration = animateDuration
        }
        
        totalDistance = (animateDistance + wobbleAnimateDistance) * getSignForDirection(direction: direction)
        wobbleAnimateDistance = abs(wobbleAnimateDistance) * getSignForDirection(direction: direction) * -1
        
        // Animating along the X-axis or Y-axis?
        if direction == .up || direction == .down {
            constraint = yAnchorConstraint
        } else {
            constraint = xAnchorConstraint
        }
        
        // Main Course!
        self.toast.layoutIfNeeded()
        preAnimationSetup(action: action, direction: direction, constraint: constraint, totalDistance: totalDistance)
        
        CATransaction.begin()
        let timingFunction = CAMediaTimingFunction(controlPoints: 1/6, 0.10, 0, 0.90)
        CATransaction.setAnimationTimingFunction(timingFunction)
        CATransaction.setAnimationDuration(animateDuration)
        
        if wobbleAnimateDistance != 0 {
            UIView.animate(withDuration: firstLegAnimationDuration, delay: delay, animations: {
                self.firstLegAnimation(action: action, direction: direction, constraint: constraint, totalDistance: totalDistance)
                self.toast.superview?.layoutIfNeeded()
            }) { _ in
                UIView.animate(withDuration: secondLegAnimationDuration, delay: 0, animations: {
                    self.secondLegAnimation(action: action, direction: direction, constraint: constraint, totalDistance: totalDistance)
                    self.toast.superview?.layoutIfNeeded()
                }, completion: { _ in
                    if self.persist == false && action == .entry {
                        self.exitDelayTimer = CountdownTimer(duration: self.displayDuration, selector: #selector(self.exitAction), target: self)
                        self.exitDelayTimer.start()
                    }
                    if self.toast.designConfig.labelTitles.count > 1 && action == .entry {
                        self.labelAnimateTimer = Timer.scheduledTimer(timeInterval: self.labelTitleAnimateDuration, target: self, selector: #selector(self.animateLabel), userInfo: nil, repeats: true)
                    }
                    if action == .exit {
                        self.toast.removeToast()
                    }
                })
            }
        } else {
            UIView.animate(withDuration: animateDuration, animations: {
                self.firstLegAnimation(action: action, direction: direction, constraint: constraint, totalDistance: totalDistance)
                self.toast.superview?.layoutIfNeeded()
                debugPrint(self.toast.frame.midY)
            }, completion: { _ in
                if self.persist == false && action == .entry {
                    self.exitDelayTimer = CountdownTimer(duration: self.displayDuration, selector: #selector(self.exitAction), target: self)
                    self.exitDelayTimer.start()
                }
                if self.toast.designConfig.labelTitles.count > 1 && action == .entry {
                    self.labelAnimateTimer = Timer.scheduledTimer(timeInterval: self.labelTitleAnimateDuration, target: self, selector: #selector(self.animateLabel), userInfo: nil, repeats: true)
                }
                if action == .exit {
                    self.toast.removeToast()
                }
            })
        }
        CATransaction.commit()
    }
    
    public func adjustForKeyboard(height: CGFloat, keyboardWillShow: Bool) {
        var offset = height
        UIView.animate(withDuration: 0.75) {
            if let constraint = self.yAnchorConstraint, self.toast.superview != nil {
                let frame = self.toast.superview?.frame
                let labelHeight = self.toast.designConfig.labelTitles[0].height(withConstrainedWidth: (frame?.width)! * self.toast.designConfig.widthMultiplier, font: self.toast.label.font)
                if keyboardWillShow {
                    offset += (labelHeight + 25)
                } else {
                    offset -= (labelHeight + 25)
                }
                constraint.constant += offset
                self.toast.superview?.layoutIfNeeded()
            }
        }
    }
    
    //MARK: - SELECTORS
    @objc func exitAction() {
//        debugPrint("exit action")
        if toast.alpha == 1 {
            if labelAnimateTimer != nil {
                labelAnimateTimer.invalidate()
            }
            action(action: .exit, delay: 0)
        }
    }
    
    @objc func animateLabel() {
        let titles = toast.designConfig.labelTitles
        let currentIndex = toast.designConfig.labelTitles.index(of: toast.label.text!)
        var index = titles.index(after: currentIndex!)
        if index >= titles.count {
            index = titles.index(0, offsetBy: 0)
        }
        
        UIView.animate(withDuration: labelTitleFadeDuration, animations: {
            self.toast.label.alpha = 0
            self.toast.superview?.layoutIfNeeded()
        }, completion: { _ in
            UIView.animate(withDuration: self.labelTitleFadeDuration, animations: {
                self.toast.label.text = titles[index]
                self.toast.label.alpha = 1
                self.toast.superview?.layoutIfNeeded()
            })
        })
    }
    
    //MARK: HELPER METHODS FOR ANIMATION
    
    /// Sets up the toast at the starting position for the required animation
    ///
    /// - Parameters:
    ///   - action: entry/exit
    ///   - direction: up/down/left/right/center
    ///   - constraint: constraint with which the animation takes place (centerX for x-axis animation and centerY for y-axis)
    ///   - totalDistance: the distance of animation
    func preAnimationSetup(action: ToastAction, direction: ToastDirection, constraint: NSLayoutConstraint, totalDistance: CGFloat) {
        if let type = toast.type {
            switch type {
            case .action, .normal, .custom:
                if direction == .center {
                    wobbleAnimateDistance = abs(wobbleAnimateDistance)
                }
                if action == .entry {
                    if direction == .center {
                        widthAnchorConstraint.constant = 0
                        heightAnchorConstraint.constant = 0
                        toast.label.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                        self.toast.superview?.layoutIfNeeded()
                        self.toast.layoutIfNeeded()
                        self.toast.label.layoutIfNeeded()
                    } else {
                        constraint.constant -= totalDistance
                        self.toast.superview?.layoutIfNeeded()
                    }
                }
            case .banner, .progressIndicator:
                if action == .entry {
                    constraint.constant -= (toast.frame.height) * getSignForDirection(direction: direction)
                    self.toast.superview?.layoutIfNeeded()
                }
            }
        }
    }
    
    /// The first half of animation (Lead up to the wobble or the animation after it)
    ///
    /// - Parameters:
    ///   - action: entry/exit
    ///   - direction: up/down/left/right/center
    ///   - constraint: constraint with which the animation takes place (centerX for x-axis animation and centerY for y-axis)
    ///   - totalDistance: the distance of animation
    func firstLegAnimation(action: ToastAction, direction: ToastDirection, constraint: NSLayoutConstraint, totalDistance: CGFloat) {
        if let type = toast.type {
            switch type {
            case .action, .normal, .custom:
                if action == .entry {
                    switch direction {
                    case .center:
                        widthAnchorConstraint.constant = toast.designConfig.width + wobbleAnimateDistance
                        heightAnchorConstraint.constant = toast.designConfig.height + wobbleAnimateDistance
                        toast.label.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
                    case .up, .down, .left, .right:
                        constraint.constant += totalDistance
                    }
                    toast.alpha = toast.designConfig.alpha
                } else if action == .exit {
                    switch direction {
                    case .center:
                        widthAnchorConstraint.constant += wobbleAnimateDistance
                        heightAnchorConstraint.constant += wobbleAnimateDistance
                        toast.label.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
                    case .up, .down, .left, .right:
                        constraint.constant += wobbleAnimateDistance
                    }
                }
            case .banner, .progressIndicator:
                if action == .entry {
                    constraint.constant += (toast.frame.height) * getSignForDirection(direction: direction)
                } else {
                    constraint.constant += wobbleAnimateDistance
                }
            }
        }
    }
    
    /// Second hald of the animation (Lead up to the wobble or the animation after it)
    ///
    /// - Parameters:
    ///   - action: entry/exit
    ///   - direction: up/down/left/right/center
    ///   - constraint: constraint with which the animation takes place (centerX for x-axis animation and centerY for y-axis)
    ///   - totalDistance: the distance of animation
    func secondLegAnimation(action: ToastAction, direction: ToastDirection, constraint: NSLayoutConstraint, totalDistance: CGFloat) {
        if let type = toast.type {
            switch type {
            case .normal, .action, .custom:
                if action == .entry {
                    switch direction {
                    case .center:
                        widthAnchorConstraint.constant -= wobbleAnimateDistance
                        heightAnchorConstraint.constant -= wobbleAnimateDistance
                        toast.label.transform = CGAffineTransform(scaleX: 1, y: 1)
                    case .up, .down, .left, .right:
                        constraint.constant += wobbleAnimateDistance
                    }
                } else if action == .exit {
                    switch direction {
                    case .center:
                        widthAnchorConstraint.constant = 0
                        heightAnchorConstraint.constant = 0
                        toast.label.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    case .up, .down, .left, .right:
                        constraint.constant += totalDistance
                    }
                    toast.alpha = 0
                }
            case .banner, .progressIndicator:
                if action == .entry {
                    constraint.constant += wobbleAnimateDistance
                } else {
                    constraint.constant += (toast.frame.height) * getSignForDirection(direction: direction)
                }
            }
        }
    }
    
    
    /// You need to remove both the timers that you keep for maintaining delay, and label animation. Do this atleast while removing the toast or you'll have the timers running forever for every toast you make. Oh boy won't that be fun! :D
    func removeTimers() {
        if exitDelayTimer != nil {
            exitDelayTimer.remove()
        }
        if labelAnimateTimer != nil {
            labelAnimateTimer.invalidate()
            labelAnimateTimer = nil
        }
    }
}

//MARK: - Animation Utilities
extension ToastAnimationConfig {
    func getSignForDirection(direction: ToastDirection) -> CGFloat {
        switch direction {
        case .up, .left:
            return -1
        case .down, .right, .center:
            return 1
        }
    }
}
