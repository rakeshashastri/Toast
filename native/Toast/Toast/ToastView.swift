//
//  ToastView.swift
//
//  Created by Rakesha Shastri on 10/01/18.
//

import UIKit

public class ToastView: UIView {
    
    //MARK: - CONFIG ELEMENTS
    public var animationConfig: ToastAnimationConfig
    
    public var designConfig: ToastDesignConfig
    
    public var type: ToastType!
//    public var isShowing: Bool = false
    
    //MARK: - QUEUE HANDLING
    public static var toastQueue: [ToastView] = []
    public static var toastInViewPosition: Int = 0
    public static var isActive: Bool = false
    
    //MARK: - UI ELEMENTS
    public var parentView: UIView!
    
    public lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    public lazy var actionButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.contentMode = .center
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    public lazy var progressIndicator: UIActivityIndicatorView = {
        let progressIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        progressIndicator.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        progressIndicator.hidesWhenStopped = true
        progressIndicator.startAnimating()
        return progressIndicator
    }()
    
    //MARK: - HELPER VARIABLES
    var defaultPosition: CGPoint = CGPoint(x: 0, y: 0)
    var keyboardHeight: CGFloat = 0
    
    // TODO: v2.0
    //    lazy var swipeDictionary: [ToastPosition : [UISwipeGestureRecognizerDirection]] = {
    //        var dictionary: [ToastPosition : [UISwipeGestureRecognizerDirection]] = [:]
    //        dictionary[.bottom] = [.down]
    //        dictionary[.center] = [.down, .up]
    //        dictionary[.top] = [.up]
    //        return dictionary
    //    }()
    
    override init(frame: CGRect) {
        self.animationConfig = ToastAnimationConfig()
        self.designConfig = ToastDesignConfig()
        super.init(frame: frame)
    }
    
    //MARK: - CONVENIENCE INITIALIZERS
    convenience init(view: UIView?, type: ToastType, keyboardHandlingRequired: Bool = false, animationConfig: ToastAnimationConfig, designConfig: ToastDesignConfig) {
        self.init(frame: CGRect.zero)
        
        parentView = view
        self.type = type
        self.animationConfig = animationConfig
        self.designConfig = designConfig
        
        addUIElements()
        addGestures()
        addOrientationObserver()
        
        designConfig.toast = self
        animationConfig.toast = self
        
//        if keyboardHandlingRequired {
//            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: .UIKeyboardDidHide, object: nil)
//
//        }
    }
    
    deinit {
        debugPrint("Toast deinitialized")
//        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        let KeyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        keyboardHeight = KeyboardFrame.height
//        animationConfig.adjustForKeyboard(height: keyboardHeight)
//    }
//
//    @objc func keyboardDidHide(notification: NSNotification) {
//        let KeyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        keyboardHeight = KeyboardFrame.height
//        animationConfig.adjustForKeyboard(height: -keyboardHeight)
//    }
    
    //MARK: - HELPER METHODS
    func addUIElements() {
        let padding: CGFloat = 10
        let animationAdjustmentOffset: CGFloat = 0
        
        //        if type == .banner {
        //            animationAdjustmentOffset = animationConfig.wobbleAnimateDistance * 1.5
        //        } else if type == .progressIndicator {
        //            animationAdjustmentOffset = -animationConfig.wobbleAnimateDistance * 1.5
        //        }
        
        if type == .action || type == .banner {
            addSubview(actionButton)
            
            actionButton.translatesAutoresizingMaskIntoConstraints = false
            if type == .action {
                actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2 * padding).isActive = true
            } else {
                actionButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            }
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: animationAdjustmentOffset).isActive = true
            
            //MARK: TODO try to come up with a better alternative
            if type == .action {
                actionButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
                actionButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
            } else if type == .banner {
                actionButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
                actionButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
            }
        }
        
        if type == .progressIndicator {
            addSubview(progressIndicator)
            
            progressIndicator.translatesAutoresizingMaskIntoConstraints = false
            progressIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17).isActive = true
            progressIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: animationAdjustmentOffset).isActive = true
        }
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: animationAdjustmentOffset).isActive = true
        
        if progressIndicator.superview != nil {
            label.leadingAnchor.constraint(equalTo: progressIndicator.trailingAnchor, constant: padding).isActive = true
        } else {
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17).isActive = true
        }
        
        if actionButton.superview != nil {
            if type == .action {
                label.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -padding).isActive = true
            } else if type == .banner {
                label.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor).isActive = true
            }
        } else {
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2 * padding).isActive = true
        }
    }
    
    func addGestures() {
        if type == .normal || type == .action || type == .custom {
            isUserInteractionEnabled = true
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction))
            panGesture.delegate = self
            addGestureRecognizer(panGesture)
        } else if type == .progressIndicator || type == .banner {
            // TODO: v2.0
            //            for direction in swipeDictionary[animationConfig.position]! {
            //                let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeResponse))
            //
            //                swipeGesture.direction = direction
            //                addGestureRecognizer(swipeGesture)
            //            }
        }
    }
    // TODO: v2.0
    //    @objc func swipeResponse() {
    //        animationConfig.action(action: .exit)
    //    }
    
    func addOrientationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc func orientationChanged() {
        designConfig.resizeForOrientationChange()
    }
    
    /// Displays the toast
    public func showToast() {
//        isShowing = true
        if ToastView.toastQueue.index(of: self) == nil {
            if parentView != nil {
                ToastView.toastQueue.insert(self, at: ToastView.toastInViewPosition)
                ToastView.toastInViewPosition += 1
                debugPrint("ToastInViewPosition \(ToastView.toastInViewPosition)")
            } else {
                ToastView.toastQueue.append(self)
            }
        }
        
        DispatchQueue.main.async {
            if !ToastView.isActive {
                self.addUIElements()
                self.designConfig.setUpFrameAndPosition()
                self.designConfig.setUpLook()
                
                ToastView.isActive = true
                self.animationConfig.action(action: .entry, delay: 0)
            }
        }
    }
    
    /// Removes toast. Please don't forget to remove the timers too! Already done here. Just reminding if you happen to change it.
    public func removeToast() {
//        if !isShowing {
//            return
//        }
//        isShowing = false
        animationConfig.removeTimers()
        
        if parentView != nil {
            ToastView.toastInViewPosition -= 1
            if ToastView.toastInViewPosition < 0 {
                ToastView.toastInViewPosition = 0
            }
            debugPrint("ToastInViewPosition \(ToastView.toastInViewPosition)")
        }
        ToastView.isActive = false
        if let index = ToastView.toastQueue.index(of: self) {
            ToastView.toastQueue.remove(at: index)
        }
        
        if ToastView.toastQueue.count > 0 {
            let nextToast = ToastView.toastQueue.first
            nextToast?.showToast()
        }
        removeFromSuperview()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ToastView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
}

// MARK: - PAN GESTURE SELECTORS + SUPPORT METHODS
extension ToastView {
    
    @objc func panAction(gestureRecognizer: UIGestureRecognizer) {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGesture.translation(in: self.superview)
            let speedThreshold: CGFloat = 300
            let fadeDistance: CGFloat = 100
            
            if gestureRecognizer.state == .began {
                if animationConfig.exitDelayTimer != nil {
                    animationConfig.exitDelayTimer.pause()
                }
                defaultPosition = center
            }
            
            if gestureRecognizer.state == .ended {
                if animationConfig.exitDelayTimer != nil {
                    animationConfig.exitDelayTimer.smartResume()
                }
            }
            
            let panVelocity = panGesture.velocity(in: self.superview)
            
            center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
            
            panGesture.setTranslation(CGPoint.zero, in: self.superview)
            if panGesture.state == .cancelled || panGesture.state == .ended {
                if panVelocity.x > speedThreshold || panVelocity.x < -speedThreshold || panVelocity.y > speedThreshold || panVelocity.y < -speedThreshold {
                    let fadeDistanceCoordinates = calculateDistanceCoordinates(velocity: panVelocity, distance: fadeDistance)
                    let fadeTime = calculateFadeTime(fadeDistance: fadeDistance, panVelocity: panVelocity)
                    
                    UIView.animate(withDuration: fadeTime, animations: {
                        self.center = CGPoint(x: self.center.x + fadeDistanceCoordinates.x, y: self.center.y + fadeDistanceCoordinates.y)
                        self.alpha = 0
                        self.superview?.layoutIfNeeded()
                    }, completion: { (true) in
                        self.removeToast()
                    })
                } else {
                    UIView.animate(withDuration: 0.60, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.70, options: .curveEaseInOut, animations: {
                        self.center = self.defaultPosition
                        self.superview?.layoutIfNeeded()
                    }, completion: nil)
                }
            }
        }
    }
    
    //MARK: - HELPERS METHODS FOR CALCULATING POSITION AND TIME FOR GIVEN SPEED (Stay away if you don't like math...oh wait it's physics. Seems like my 11th grade tuitions are finally showing dividends. ¯\_(ツ)_/¯)
    func calculateDistanceCoordinates(velocity: CGPoint, distance: CGFloat) -> CGPoint {
        if velocity.x == 0 {
            var negativeFlag: CGFloat = 1
            if velocity.y.sign == .minus {
                negativeFlag *= -1
            }
            return CGPoint(x: 0, y: distance * negativeFlag)
        }
        if velocity.y == 0 {
            var negativeFlag: CGFloat = 1
            if velocity.x.sign == .minus {
                negativeFlag *= -1
            }
            return CGPoint(x: distance * negativeFlag, y: 0)
        }
        let ratio = abs(velocity.y/velocity.x)
        let k = (distance * distance)/(1+(ratio*ratio))
        var xDistance = k.squareRoot()
        var yDistance = ratio * xDistance
        if velocity.x < 0 {
            xDistance *= -1
        }
        if velocity.y < 0 {
            yDistance *= -1
        }
        let point = CGPoint(x: xDistance, y: yDistance)
        return point
    }
    
    func calculateFadeTime(fadeDistance: CGFloat, panVelocity: CGPoint) -> TimeInterval {
        let velocity = ((panVelocity.x * panVelocity.x) + (panVelocity.y * panVelocity.y)).squareRoot()
        let time = fadeDistance/velocity
        return TimeInterval(time)
    }
    
}


// MARK: - DEVELOPER COMMENTS
//
// - Using center anchors because setting up toast in different positions will be uniform and clear.

