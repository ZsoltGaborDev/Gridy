//
//  File.swift
//  Gridy
//
//  Created by zsolt on 09/03/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit

class Creation {
    var image: UIImage
    static var defaultImage : UIImage {
        return UIImage.init(named: "Lake")!
    }
    init() {
        image = Creation.defaultImage
    }
    func reset() {
        image = Creation.defaultImage
    }
}
