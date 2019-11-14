//
//  GameOverView.swift
//  Gridy
//
//  Created by zsolt on 24/04/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit

class GameOverView: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var scoreListView: UIView!
    @IBOutlet weak var yourScore: UILabel!
    @IBOutlet weak var totalMoves: UILabel!
    @IBOutlet weak var wrongMoves: UILabel!
    @IBOutlet weak var correctMoves: UILabel!
    
    //MARK: Variables
    var popUpImage = UIImage()
    var rightMoves = Int()
    var moves = Int()
    var score = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = popUpImage
        correctMoves.text = "Correct Moves: \(rightMoves)"
        totalMoves.text = "Total Moves: \(moves)"
        wrongMoves.text = "Wrong Moves: \(moves - rightMoves)"
        yourScore.text = "Your Score: \(score)"
        self.visualEffectView.effect = nil
    }
    
    @IBAction func optionsButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.7) {
            self.visualEffectView.effect = UIBlurEffect(style: .regular)
            self.scoreListView.alpha = 0
            self.optionsButton.alpha = 0
            self.showAlert()
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Well done!", message: "Your Score: \(score) \nTotal Moves: \(moves) \nCorrect Moves: \(rightMoves) \nWrong Moves: \(moves - rightMoves)", preferredStyle: .alert)
      
        alert.addAction(UIAlertAction(title: "New Game!", style: UIAlertAction.Style.default) {(action) in
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
               appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
               (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
            }
            })
      
        alert.addAction(UIAlertAction(title: "Share", style: .default) {(action) in
            self.displaySharingOptions()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) {(action) in
            UIView.animate(withDuration: 0.2) {
                self.visualEffectView.effect = nil
                self.scoreListView.alpha = 1
                self.optionsButton.alpha = 1
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
}
