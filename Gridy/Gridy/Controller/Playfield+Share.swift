//
//  Playfield+Share.swift
//  Gridy
//
//  Created by zsolt on 20/04/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit

extension PlayfieldView {
    
    func showShareButton() {
        if rightMoves == CVOneImages.count {
            shareButton.isHidden = false
        } else {
            shareButton.isHidden = true
        }
    }
    func displaySharingOptions() {
        shareButton.isHidden = true
        newGameButton.isHidden = true
        //prepare content to share
        let note = "I MADE IT!"
        let image = composeCreationImage()
        let items = [image as Any, note as Any]
        //create activity view controller
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        //adapt for iPad
        activityViewController.popoverPresentationController?.sourceView = view
        //present activity view controller
        present(activityViewController, animated: true, completion: nil)
    }
    func composeCreationImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let viewToShare = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        newGameButton.isHidden = false
        shareButton.isHidden = false
        return viewToShare
    }
    
}
