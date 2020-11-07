//
//  ToastDesignConfig.swift
//
//  Created by Rakesha Shastri on 11/01/18.
//

import Foundation
import UIKit

public class ToastDesignConfig {
    
    var toast: ToastView!
    
    //MARK: - Dimension variables
    public var height: CGFloat = 30
    public var heightMultiplier: CGFloat = 0
    public var width: CGFloat = 0
    public var widthMultiplier: CGFloat = 0.90
    public var xOffset: CGFloat = 0
    public var yOffset: CGFloat = 0
    
    var defaultXOffset: CGFloat = 30
    var defaultYOffset: CGFloat = 25
    var padding: CGFloat = 0
    
    //MARK: - Visual variables
    public var backgroundColor: UIColor = UIColor.black
    public var borderWidth: CGFloat = 0.10
    public var borderColor: CGColor = UIColor.lightGray.cgColor
    public var cornerRadius: CGFloat = 4
    public var alpha: CGFloat = 1
    
    //MARK: - Label variables
    public var labelTitles: [String] = ["Forgot to add the title bruh? :P"]
    public var labelFont: UIFont
    public var labelTextColor: UIColor = UIColor.white
    public var labelTextAlignment: NSTextAlignment = .center
    
    //MARK: - Button variables
    public var buttonImage: UIImage!
    public var buttonTitle: String = "?"
    public var buttonTitleColor: UIColor = .black
    public var buttonSelectedTitle: String!
    public var buttonSelectedTitleColor: UIColor!
    public var buttonTintColor: UIColor = .black
    public var buttonFont: UIFont
    public var buttonTextAlignment: NSTextAlignment = .center
    public var selector: Selector?
    public var selectorTarget: Any?
    
    public init() {
        labelFont = UIFont.systemFont(ofSize: 16)
        buttonFont =  UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    /// Sets up color, font, border,... you name it. Use this method if you need to reset the design of your toast incase you modified the config after setting it up the first time.
    public func setUpLook() {
        switch toast.type {
        case .normal, .action, .custom:
            toast.alpha = 0
        case .banner, .progressIndicator:
            toast.alpha = alpha
        case .none:
            break
        case .some(_):
            break
        }
        
        toast.backgroundColor = backgroundColor
        toast.layer.cornerRadius = cornerRadius
        toast.layer.borderColor = borderColor
        toast.layer.borderWidth = borderWidth
        toast.layer.masksToBounds = true
        
        let label = toast.label
        label.text = labelTitles.first!
        label.font = labelFont
        label.textColor = labelTextColor
        label.textAlignment = labelTextAlignment
        
        let button = toast.actionButton
        
        if toast.type == .banner {
            if buttonImage == nil {
                let bundle = Bundle(for: ToastView.self)
                let bundleURL = bundle.resourceURL?.appendingPathComponent("Toast.bundle")
                if let bundleURLFound = bundleURL {
                    let resourceBundle = Bundle(url: bundleURLFound)
                    if let resourceBundleFound = resourceBundle {
                        buttonImage = UIImage(named: "closeIcon", in: resourceBundleFound, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                    } else {
                        buttonImage = UIImage(named: "closeIcon", in: Bundle(for: ToastView.self), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                    }
                }
            }
            button.setImage(buttonImage, for: .normal)
            button.addTarget(self, action: #selector(dismissToast), for: .touchUpInside)
        } else if toast.type == .action {
            button.setTitle(buttonTitle, for: .normal)
            if buttonSelectedTitle != nil {
                button.setTitle(buttonSelectedTitle, for: .selected)
            }
            if selector != nil {
                button.addTarget(selectorTarget, action: selector!, for: .touchUpInside)
            }
        }
        button.tintColor = buttonTintColor
        button.titleLabel?.font = buttonFont
        button.setTitleColor(buttonTitleColor, for: .normal)
        button.setTitleColor(buttonTitleColor.withAlphaComponent(0.60), for: .highlighted)
        button.titleLabel?.textAlignment = buttonTextAlignment
    }
    
    @objc func dismissToast() {
        toast.animationConfig.action(action: .exit)
    }
    
    /// Sets up dimensions and position of the toast.
    public func setUpFrameAndPosition() {
        let layoutGuide: UILayoutGuide!
        let frame: CGRect!
        let superView: UIView!
        var tabBarAdjustment: CGFloat = 0
        
        // Where to add the toast.
        if toast.parentView == nil {
            let window = UIApplication.shared.keyWindow
            superView = window
            if let tabBarController = window?.rootViewController as? UITabBarController {
                if !tabBarController.tabBar.isHidden {
                    if tabBarController.viewIfLoaded?.window != nil {
                        tabBarAdjustment = tabBarController.tabBar.frame.size.height
                    }
                }
            }
        } else {
            superView = toast.parentView
        }
        
        superView.addSubview(toast)
        frame = superView.frame
        layoutGuide = superView.layoutMarginsGuide
//        if #available(iOS 11.0, *) {
//            layoutGuide = superView.safeAreaLayoutGuide
//        } else {
//            layoutGuide = superView.layoutMarginsGuide
//        }
        
        // Handle for multiple strings later
        let labelHeight = labelTitles[0].height(withConstrainedWidth: frame.width * widthMultiplier, font: toast.label.font)
        
        // Default offset incase you don't set the offset explicitly
        if yOffset == 0 {
            if toast.type == .normal || toast.type == .action || toast.type == .custom {
                if yOffset == 0 && (toast.animationConfig.position == .bottom || toast.animationConfig.position == .top) {
                    yOffset = defaultYOffset
                }
                
                // Only y-axis varies from the center when setting up toast. x-axis is always at the center. So i'm setting the default value for bottom and top offsets.
                switch toast.animationConfig.position {
                case .bottom:
                    yOffset = ((labelHeight + height)/2 + yOffset + tabBarAdjustment)
                case .top:
                    yOffset = ((labelHeight + height)/2 + yOffset)
                case .center:
                    break
                }
            } else if toast.type == .banner || toast.type == .progressIndicator {
                yOffset = 0
            }
        }
        
        if toast.animationConfig.position == .bottom {
            yOffset *= -1
        }
        
        toast.translatesAutoresizingMaskIntoConstraints = false
        
        let animationConfig = toast.animationConfig
        
        //MARK: - Position constraints
        animationConfig.xAnchorConstraint = toast.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor, constant: xOffset)
        
        if toast.type == .banner {
            animationConfig.yAnchorConstraint = toast.topAnchor.constraint(equalTo: layoutGuide.topAnchor)
        } else if toast.type == .progressIndicator {
            animationConfig.yAnchorConstraint = toast.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
        } else {
            switch toast.animationConfig.position {
            case .bottom:
                animationConfig.yAnchorConstraint = toast.centerYAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: yOffset)
            case .center:
                animationConfig.yAnchorConstraint = toast.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor, constant: yOffset)
            case .top:
                animationConfig.yAnchorConstraint = toast.centerYAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: yOffset)
            }
        }
        
        animationConfig.xAnchorConstraint.isActive = true
        animationConfig.yAnchorConstraint.isActive = true
        
        //MARK: - Size constraints
        if heightMultiplier != 0 {
            height = frame.height * heightMultiplier
        }
        
        if widthMultiplier != 0 {
            width = frame.width * widthMultiplier
        }
        
//        if toast.type == .banner || toast.type == .progressIndicator {
//            height += toast.animationConfig.wobbleAnimateDistance
//        }
        
        animationConfig.heightAnchorConstraint = toast.heightAnchor.constraint(equalTo: toast.label.heightAnchor, multiplier: 1, constant: height)
        animationConfig.widthAnchorConstraint = toast.widthAnchor.constraint(equalToConstant: width)
        
        animationConfig.heightAnchorConstraint.isActive = true
        animationConfig.widthAnchorConstraint.isActive = true
        
        toast.superview?.layoutIfNeeded()
    }
    
    
    //MARK: - Orientation Support
    func resizeForOrientationChange() {
        if toast.superview != nil {
            width = (toast.superview?.frame.width)! * widthMultiplier
            toast.animationConfig.widthAnchorConstraint.constant = width
            toast.superview?.layoutIfNeeded()
        }
    }
}


