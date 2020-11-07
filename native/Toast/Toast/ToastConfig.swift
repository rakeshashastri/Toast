//
//  ToastConfig.swift
//
//  Created by Rakesha Shastri on 10/01/18.
//

import Foundation
import UIKit

/// Toast Position
///
/// - top: positioned at the top of view/window
/// - center: positioned at the center of view/window
/// - bottom: positioned at the bottom of view/window
public enum ToastPosition {
    case top
    case center
    case bottom
}

/// Toast Type
///
/// - normal: normal bar toast that slides from the bottom and goes back the same way
/// - banner: end to end toast at the top of the view/window
/// - action: normal bar toast + action button on the right
/// - progressIndicator: banner toast + loading indicator at the bottom of the view/window
/// - custom: normal bar toast with a lot of user specified changes from the default toast. Note: You can't have the loading indicator or action button in custom toast.
public enum ToastType {
    case normal
    case banner
    case action
    case progressIndicator
    case custom
}

/// Toast Color
///
/// - black: 54/54/54 & white (Default)
/// - red: 216/98/113 & 54/54/54
/// - yellow: 255/227/121 & 54/54/54
/// - green: 184/233/134 & 54/54/54
public enum ToastColor {
    case red
    case yellow
    case green
}

/// Toast Direction
///
/// Direction is purely movement based not position.
/// eg: If entry says 'right', it means the toast moves to the right till it reaches the center of the screen. It may be a bit confusing to understand but this is better when doing animations. Sowie. :x
public enum ToastDirection: Int {
    case right
    case left
    case up
    case down
    case center
}

/// Toast Action
///
public enum ToastAction {
    case entry
    case exit
}
