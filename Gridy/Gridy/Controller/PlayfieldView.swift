//
//  PlayfieldView.swift
//  Gridy
//
//  Created by zsolt on 31/01/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit

class PlayfieldView: UIViewController {
    var rawImage: UIImage?
    @IBOutlet weak var puzzleImage: UICollectionView!
    
    func setImage() {
        if let imageToSplit = rawImage {
        test.image = imageToSplit
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var test: UIImageView!
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
