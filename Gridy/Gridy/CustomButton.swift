//
//  CustomButton.swift
//  Gridy
//
//  Created by zsolt on 02/02/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit

class CustomButton: UIView {
    override func draw(_ rect: CGRect) {
        super .draw(rect)
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
}
