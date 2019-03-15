//
//  ViewController.swift
//  Gridy
//
//  Created by zsolt on 02/02/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var gridyLogo: UIImageView!
    @IBOutlet weak var orLoadYourOwnLabel: UILabel!
    @IBOutlet weak var challengeYourselfLabel: UILabel!
    
    var creation = Creation.init()
    var localImages = [UIImage].init()
    let imagePickerController = UIImagePickerController()
    var newImage = UIImage.init()
    
    @IBAction func cameraButton(_ sender: UIButton) {
        displayCamera()
    }
    @IBAction func photoLibraryButton(_ sender: UIButton) {
        displayLibrary()
    }
    @IBAction func pickButton(_ sender: UIButton) {
        pickRandom()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mySegue" {
            let vc = segue.destination as! ImageEditorView
            vc.incomingImage = creation.image
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectLocalImageSet()
    }
    func displayCamera() {
        let sourceType = UIImagePickerController.SourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            let noPermissionMessage = "Looks like Gridy doesn't have access to your camera :( Please use Settings app on your device to permit Gridy accessing your camera"
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {(granted) in
                    if granted {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            }
        }
        else {
            troubleAlert(message: "Sincere apologise, it looks like we can't access your camera at this time")
        }
    }
    func displayLibrary() {
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = PHPhotoLibrary.authorizationStatus()
            let noPermissionStatusMessage = "Looks like Gridy haven't access to your photos :( Please use Setting app on your device to permit Gridy accessing your library"
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus == .authorized {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionStatusMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionStatusMessage)
            }
        }
        else {
            troubleAlert(message: "Sincere apologise, it looks like we can't access your photo library at this time")
        }
    }
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // got an image
        let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        processPicked(image: newImage)
        dismiss(animated: true, completion: { () -> Void in
            self.performSegue(withIdentifier: "mySegue", sender: self)
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func troubleAlert(message: String?) {
        let alertController = UIAlertController(title: "Oops...", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Got it.", style: .cancel)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    func pickRandom() {
        processPicked(image: randomImage())
        performSegue(withIdentifier: "mySegue", sender: self)
    }
    func processPicked(image: UIImage?) {
        if  let newImage = image {
            creation.image = newImage
        }
    }
    func randomImage() -> UIImage? {
        let currentImage = creation.image
        if localImages.count > 0 {
            while true {
                let randomIndex = Int(arc4random_uniform(UInt32(localImages.count)))
                let newImage = localImages[randomIndex]
                if newImage != currentImage {
                    return newImage
                }
            }
        }
        return nil
    }
    func collectLocalImageSet() {
        localImages.removeAll()
        let imageNames = ["Fawn", "Island", "Lake", "Mountain", "Rabbit", "Wood"]
        for name in imageNames {
            if let image = UIImage.init(named: name) {
                localImages.append(image)
            }
        }
    }
}


