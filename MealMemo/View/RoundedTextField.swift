//
//  RoundedTextField.swift
//  MealMemo
//
//  Created by Vincent Hunter on 3/20/25.
//

import UIKit

class RoundedTextField: UITextField {
    
    //First 3 Methods control text indentation

    let padding = UIEdgeInsets(top:0, left: 15, bottom: 15, right: 0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    //Last method controls rounded corners
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }

}
