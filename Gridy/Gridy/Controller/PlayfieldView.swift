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
import AudioToolbox

class PlayfieldView: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var CVOne: UICollectionView!
    @IBOutlet weak var CVTwo: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var popUpView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    
    //MARK: - Variables
    var toReceive = [UIImage]()
    var CVOneImages :[UIImage]!
    var CVTwoImages = [UIImage]()
    var fixedImages = [UIImage(named: "Blank"), UIImage(named: "Gridy-lookup")]
    let frame = UIView()
    var moves: Int = 0
    var rightMoves: Int = 0
    var popUpImage = UIImage()
    
    //MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        CVOneImages = toReceive
        CVOneImages.shuffle()
        popUpView.image = popUpImage
        popUpView.isHidden = true
        scoring(moves: moves)
        for image in fixedImages {
            if let image = image {
                CVOneImages.append(image)
            } else {
                fatalError("Could not find a fixed image, this error needs better structured and/or handled")
            }
        }
        CVOne.dragInteractionEnabled = true
        CVTwo.dragInteractionEnabled = true
        if CVTwoImages.count == 0 {
            if let blank = UIImage(named: "Blank") {
                var temp = [UIImage]()
                for _ in toReceive {
                    temp.append(blank)
                }
                CVTwoImages = temp
                CVTwo.reloadData()
            } else {
                fatalError("Could not create second collection view array, this error needs better handled")
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func newGameAction(_ sender: Any) { }

    //@IBAction func unwindToViewController(_ sender: UIStoryboardSegue) { }
    
    func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "my3rdSegue" {
            let vc3 = segue.destination as! GameOverView
            vc3.popUpImage = popUpImage
            vc3.rightMoves = rightMoves
            vc3.moves = moves - 1
            vc3.score = yourScore()
        }
    }
}
