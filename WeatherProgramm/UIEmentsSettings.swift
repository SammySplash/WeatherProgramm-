//
//  UIEmentsSettings.swift
//  WeatherProgramm
//
//  Created by user on 4/5/20.
//  Copyright © 2020 HlebSamoilik. All rights reserved.
//

import Foundation
import UIKit

class UIElementsSettings {
    static func addParallaxToView(vw: UIImageView) {
        let amount = 10
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        let group = UIMotionEffectGroup()
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }
}
