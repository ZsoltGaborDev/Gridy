//
//  GameOverView.swift
//  Gridy
//
//  Created by zsolt on 24/04/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit

class GameOverView: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var popUpView: UIImageView!
    @IBOutlet weak var correctMoves: UILabel!
    @IBOutlet weak var wrongMoves: UILabel!
    @IBOutlet weak var totalMoves: UILabel!
    @IBOutlet weak var yourScore: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    
    
    var popUpImage = UIImage()
    var rightMoves = Int()
    var moves = Int()
    var score = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.image = popUpImage
        popUpView.isHidden = true
        backgroundImageView.image = popUpImage
        correctMoves.text = "Correct Moves: \(rightMoves)"
        totalMoves.text = "Total Moves: \(moves)"
        wrongMoves.text = "Wrong Moves: \(moves - rightMoves)"
        yourScore.text = "Your Score: \(score)"
        
        

        // Do any additional setup after loading the view.
    }
        @IBAction func share(_ sender: Any) {
            displaySharingOptions()
        }
    @IBAction func newGame(_ sender: UIButton) {
    }
    @IBAction func shareButton(_ sender: UIButton) {
    }
}
