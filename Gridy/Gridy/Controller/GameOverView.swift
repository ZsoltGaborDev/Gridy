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
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var popUpView: UIImageView!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var scoreListView: UIView!
    @IBOutlet weak var yourScore: UILabel!
    @IBOutlet weak var totalMoves: UILabel!
    @IBOutlet weak var wrongMoves: UILabel!
    @IBOutlet weak var correctMoves: UILabel!
    
    
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
        self.visualEffectView.effect = nil
    }
    
    @IBAction func optionsButtonPressed(_ sender: UIButton) {
        showAlert()
        scoreListView.isHidden = true
        optionsButton.isHidden = true
        UIView.animate(withDuration: 3) {
            self.visualEffectView.effect = UIBlurEffect(style: .regular)
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Well done!", message: "Your Score: \(score) \nTotal Moves: \(moves) \nCorrect Moves: \(rightMoves) \nWrong Moves: \(moves - rightMoves)", preferredStyle: .alert)
      
        alert.addAction(UIAlertAction(title: "New Game!", style: UIAlertAction.Style.default) {(action) in
            self.performSegue(withIdentifier: "newGameSegue", sender: self)
            })
      
        alert.addAction(UIAlertAction(title: "Share", style: .default) {(action) in
            self.displaySharingOptions()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) {(action) in
            UIView.animate(withDuration: 2) {
                self.visualEffectView.effect = nil
                self.scoreListView.isHidden = false
                self.popUpView.isHidden = true
                self.optionsButton.isHidden = false
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
}
