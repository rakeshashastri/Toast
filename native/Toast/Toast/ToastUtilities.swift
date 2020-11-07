//
//  ToastUtilities.swift
//
//  Created by Rakesha Shastri on 23/01/18.
//

import Foundation
import UIKit

public class ToastUtilities {
    
    /// Changes the user input RGB values (1-255) to required RGB values (0-1)
    ///
    /// - Parameters:
    ///   - red: red (0-255)
    ///   - green: green (0-255)
    ///   - blue: blue (0-255)
    ///   - alpha: alpha (0-1)
    /// - Returns: UIColor with specified RGBA
    public class func getUIColorWithRGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        let red = red/255
        let green = green/255
        let blue = blue/255
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
