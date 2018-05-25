//
//  EditProfileTextField.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 3/13/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit

class EditProfileTextField: UITextField {
    
    override func draw(_ rect: CGRect) {
        //        var frame = self.frame
        //        frame.size.height = 50
        //        self.frame = frame
    }
    
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: 7, left: 6, bottom: 8, right:self.frame.width - 16);
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
