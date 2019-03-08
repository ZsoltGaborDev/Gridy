//
//  Creation.swift
//  Gridy
//
//  Created by zsolt on 02/02/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit

class Creation {
    var image: UIImage
    static var defaultImage : UIImage {
    return UIImage.init(named: "City")!
    }
    init() {
        image = Creation.defaultImage
    }
    func reset() {
        image = Creation.defaultImage
    }
}
