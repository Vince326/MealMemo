//
//  NavigationController.swift
//  MealMemo
//
//  Created by Vincent Hunter on 3/10/25.
//

import UIKit

class NavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }

}
