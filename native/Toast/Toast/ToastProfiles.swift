//
//  ToastProfiles.swift
//
//  Created by Rakesha Shastri on 17/01/18.
//

import Foundation
import UIKit

public class ToastProfiles: NSObject {
    
    /// Method to get the toast based on type
    ///
    /// - Parameters:
    ///   - titleStrings: title(s) to be displayed as toast message one by one
    ///   - buttonTitle: button title (applicable only for action toast. Specifiying a value wont affect other toasts.)
    ///   - type: refer toast types in ToastConfig.swift file
    ///   - view: is toast being added to a view or to the window (Leave it be if you are adding it to window)
    ///   - target: location of the passed selector
    ///   - selector: selector to be called for actiopn button click
    /// - Returns: toast with the above parameters
    public class func getToast(titleStrings: [String], buttonTitle: String = "", type: ToastType, color: ToastColor = .yellow, view: UIView? = nil, target: Any? = nil, selector: Selector? = nil, keyboardHandlingRequired: Bool = false) -> ToastView {
        let animationConfig = getAnimationConfiguration(type: type)
        let designConfig = getDesignConfiguration(titleStrings: titleStrings, buttonTitle: buttonTitle, type: type, color: color, target: target, selector: selector)
        
        let toast = ToastView(view: view, type: type, keyboardHandlingRequired: keyboardHandlingRequired, animationConfig: animationConfig, designConfig: designConfig)
        return toast
    }
    
    @objc class func getAndShowToast(titleString: String, offset: CGFloat = 0) {
        let toast = self.getToast(titleStrings: [titleString], type: .normal)
        if offset != 0 {
            toast.designConfig.yOffset = offset
        }
        toast.showToast()
    }
    
    //MARK: - HELPER METHODS
    
    /// Get default animation configured for the selected type
    ///
    /// - Parameter type: toast type
    /// - Returns: animation configuration
    private class func getAnimationConfiguration(type: ToastType) -> ToastAnimationConfig {
        let animationConfig = ToastAnimationConfig()
        
        switch type {
        case .action, .normal:
            animationConfig.position = .bottom
            animationConfig.entryDirection = .up
            animationConfig.exitDirection = .down
            animationConfig.displayDuration = 3
            animationConfig.persist = false
        case .banner:
            animationConfig.position = .top
            animationConfig.entryDirection = .down
            animationConfig.exitDirection = .up
            animationConfig.animateDuration = 0.15
            animationConfig.wobbleDuration = 0.15
            animationConfig.persist = true
        case .progressIndicator:
            animationConfig.position = .bottom
            animationConfig.entryDirection = .up
            animationConfig.exitDirection = .down
            animationConfig.animateDuration = 0.15
            animationConfig.wobbleDuration = 0.15
            animationConfig.persist = true
        case .custom:
            // This class is not associated with custom toasts
            break
        }
        return animationConfig
    }
    
    /// Get default design configuration for the selected type
    ///
    /// - Parameters:
    ///   - titleStrings: toast label strings
    ///   - buttonTitle: button title if available
    ///   - type: toast type
    ///   - target: location fo the selector passed
    ///   - selector: selector to be called on button click
    /// - Returns: design configuration
    private class func getDesignConfiguration(titleStrings: [String], buttonTitle: String, type: ToastType, color: ToastColor, target: Any?, selector: Selector?) -> ToastDesignConfig {
        let designConfig = ToastDesignConfig()
        designConfig.labelTitles = titleStrings
        designConfig.selectorTarget = target
        designConfig.selector = selector
        
        if buttonTitle != "" {
            designConfig.buttonTitle = buttonTitle
        }
        
        switch type {
        case .action:
            designConfig.backgroundColor = ToastUtilities.getUIColorWithRGBA(red: 54, green: 54, blue: 54, alpha: 1)
            designConfig.buttonTitleColor = ToastUtilities.getUIColorWithRGBA(red: 248, green: 191, blue: 28)
            designConfig.buttonFont = .systemFont(ofSize: 14, weight: .regular)
            designConfig.labelFont = .systemFont(ofSize: 14, weight: .regular)
            designConfig.buttonSelectedTitleColor = .white
            designConfig.labelTextAlignment = .left
            designConfig.cornerRadius = 4
        case .banner:
            designConfig.widthMultiplier = 1
            switch color {
            case .red:
                designConfig.backgroundColor = ToastUtilities.getUIColorWithRGBA(red: 216, green: 98, blue: 113)
                designConfig.labelTextColor = ToastUtilities.getUIColorWithRGBA(red: 255, green: 255, blue: 255)
                designConfig.buttonTintColor = .white
            case .yellow:
                designConfig.backgroundColor = ToastUtilities.getUIColorWithRGBA(red: 255, green: 227, blue: 121)
                designConfig.labelTextColor = ToastUtilities.getUIColorWithRGBA(red: 54, green: 54, blue: 54)
                designConfig.buttonTintColor = .black
            case .green:
                designConfig.backgroundColor = ToastUtilities.getUIColorWithRGBA(red: 184, green: 233, blue: 134)
                designConfig.labelTextColor = ToastUtilities.getUIColorWithRGBA(red: 54, green: 54, blue: 54)
                designConfig.buttonTintColor = .black
            }
            designConfig.buttonFont = .systemFont(ofSize: 14, weight: .regular)
            designConfig.labelFont = .systemFont(ofSize: 14, weight: .regular)
            designConfig.labelTextAlignment = .left
            designConfig.cornerRadius = 0
        case .normal:
            designConfig.backgroundColor = ToastUtilities.getUIColorWithRGBA(red: 54, green: 54, blue: 54, alpha: 1)
            designConfig.labelFont = .systemFont(ofSize: 14, weight: .regular)
            designConfig.labelTextAlignment = .center
            designConfig.cornerRadius = 4
        case .progressIndicator:
            designConfig.widthMultiplier = 1
            designConfig.backgroundColor = ToastUtilities.getUIColorWithRGBA(red: 0, green: 0, blue: 0, alpha: 0.40)
            designConfig.labelFont = .systemFont(ofSize: 14, weight: .regular)
            designConfig.labelTextAlignment = .left
            designConfig.cornerRadius = 0
        case .custom:
            // This class is not associated with custom toasts
            break
        }
        return designConfig
    }
    
}
