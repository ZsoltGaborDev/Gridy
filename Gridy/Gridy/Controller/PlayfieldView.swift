//
//  PlayfieldView.swift
//  Gridy
//
//  Created by zsolt on 31/01/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit
import Photos
//import MobileCoreServices
import AVFoundation
//import AudioToolbox

class PlayfieldView: UIViewController, AVAudioPlayerDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var CVOne: UICollectionView!
    @IBOutlet weak var CVTwo: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var popUpView: UIImageView!
    @IBOutlet weak var newGameButton: UIButton!
    @IBAction func switchButtonOn(_ sender: UISwitch) {
        if sender .isOn {
            soundIsOn = true
        } else {
            soundIsOn = false
        }
    }
    
    //MARK: - Variables
    var toReceive = [UIImage]()
    var CVOneImages :[UIImage]!
    var CVTwoImages = [UIImage]()
    var fixedImages = [UIImage(named: "Blank"), UIImage(named: "Gridy-lookup")]
    var moves: Int = 0
    var rightMoves: Int = 0
    var popUpImage = UIImage()
    var isSelected: IndexPath?
    var soundIsOn: Bool = true
    
    
    
   
    
    //MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CVOneImages = toReceive
        CVOneImages.shuffle()
        CVOne.reloadData()
        popUpView.image = popUpImage
        popUpView.isHidden = true
        scoring(moves: moves)
        for image in fixedImages {
            if let image = image {
                CVOneImages.append(image)
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
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - IBActions
    @IBAction func newGameAction(_ sender: Any) { }
    
    func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func playSound() {
        if soundIsOn == true {
            var audioPlayer = AVAudioPlayer()
            let soundURL = Bundle.main.url(forResource: "oookay", withExtension: "wav")
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
                print("sound is playing!!")
            }
            catch {
                
                print (error)
            }
            audioPlayer.play()
        }
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
