//
//  PlayfieldView.swift
//  Gridy
//
//  Created by zsolt on 31/01/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit
import Foundation
import Photos
import MobileCoreServices

class PlayfieldView: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var popUpView: UIImageView!
    
    //MARK: - Variables
    var toReceive = [UIImage]()
    var collectionOne = [UIImage]()
    var collectionTwo = [UIImage]()
    var fixedImages = [UIImage(named: "Blank"), UIImage(named: "Gridy-lookup")]
    let frame = UIView()
    var moves: Int = 0
    var popUpImage = UIImage()
    
    //MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionOne = toReceive
        collectionOne.shuffle()
        popUpView.image = popUpImage
        popUpView.isHidden = true
        for image in fixedImages {
            if let image = image {
                collectionOne.append(image)
            } else {
                fatalError("Could not find a fixed image, this error needs better structured and/or handled")
            }
        }
        collectionView1.dragInteractionEnabled = true
        collectionView2.dragInteractionEnabled = true
        if collectionTwo == nil || collectionTwo.count == 0 {
            if let blank = UIImage(named: "Blank") {
                var temp = [UIImage]()
                for _ in toReceive {
                    temp.append(blank)
                }
                collectionTwo = temp
                collectionView2.reloadData()
            } else {
                fatalError("Could not create second collection view array, this error needs better handled")
            }
        }
    }

    //MARK: - IBActions
    @IBAction func newGameAction(_ sender: Any) { }

    @IBAction func unwindToViewController(_ sender: UIStoryboardSegue) { }
    
}
