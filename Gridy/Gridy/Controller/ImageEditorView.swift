//
//  ImageEditorView.swift
//  Gridy
//
//  Created by zsolt on 31/01/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit

class ImageEditorView: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var adjustThePuzzleImageLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBAction func StartButton(_ sender: UIButton) {
    }
    @IBOutlet weak var imageToSplit: UIImageView!
    @IBAction func XButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    var incomingImage: UIImage?
    
    func setImage() {
        if let myImage = incomingImage {
            imageToSplit.image = myImage
            backgroundImage.image = myImage
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()

        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

