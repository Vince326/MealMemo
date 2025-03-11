//
//  UIColor+Ext.swift
//  MealMemo
//
//  Created by Vincent Hunter on 3/10/25.
//

import UIKit

extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        let redValue = CGFloat(red) / 255.0
        let blueValue = CGFloat(blue) / 255.0
        let greenValue = CGFloat(green) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }
}

