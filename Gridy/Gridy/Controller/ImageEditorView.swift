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
    @IBOutlet weak var creationFrame: UIView!
    @IBOutlet weak var creationImageView: UIImageView!
    @IBAction func StartButton(_ sender: UIButton) {
        composeCreationImage()
    }
    @IBAction func XButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    var incomingImage: UIImage?
    var initialImageViewOffset = CGPoint()
    var defaults = UserDefaults.standard
    var identity = CGAffineTransform.identity
    var panRecognizer: UIPanGestureRecognizer?
    var pinchRecognizer: UIPinchGestureRecognizer?
    var rotateRecognizer: UIRotationGestureRecognizer?
    var screenshot = UIImage()
    
    func setImage() {
        if let myImage = incomingImage {
            creationImageView.image = myImage
            backgroundImage.image = myImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
        // Create gesture with target self(viewcontroller) and handler function.
        self.panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        self.pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(recognizer:)))
        self.rotateRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(self.handleRotate(recognizer:)))
        //delegate gesture with UIGestureRecognizerDelegate
        pinchRecognizer?.delegate = self
        rotateRecognizer?.delegate = self
        panRecognizer?.delegate = self
        // add gesture to creation.imageView
        self.creationImageView.addGestureRecognizer(panRecognizer!)
        self.creationImageView.addGestureRecognizer(pinchRecognizer!)
        self.creationImageView.addGestureRecognizer(rotateRecognizer!)
    }
    
    // handle UIPanGestureRecognizer
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        let gview = recognizer.view
        if recognizer.state == .began || recognizer.state == .changed {
            let translation = recognizer.translation(in: gview?.superview)
            gview?.center = CGPoint(x: (gview?.center.x)! + translation.x, y: (gview?.center.y)! + translation.y)
            recognizer.setTranslation(CGPoint.zero, in: gview?.superview)
        }
    }
    
    // handle UIPinchGestureRecognizer
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            recognizer.view?.transform = (recognizer.view?.transform.scaledBy(x: recognizer.scale, y: recognizer.scale))!
            recognizer.scale = 1.0
        }
    }
    
    // handle UIRotationGestureRecognizer
    @objc func handleRotate(recognizer: UIRotationGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            recognizer.view?.transform = (recognizer.view?.transform.rotated(by: recognizer.rotation))!
            recognizer.rotation = 0.0
        }
    }
    // mark sure you override this function to make gestures work together
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func composeCreationImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(creationFrame.bounds.size, false, 0)
        creationFrame.drawHierarchy(in: creationFrame.bounds, afterScreenUpdates: true)
        screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return screenshot
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "my2ndSegue" {
            let vc2 = segue.destination as! PlayfieldView
            vc2.rawImage = screenshot
        }
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

