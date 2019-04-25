//
//  Playfield+Share.swift
//  Gridy
//
//  Created by zsolt on 20/04/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit

extension GameOverView {
    
    func displaySharingOptions() {
        //prepare content to share
        optionsButton.isHidden = true
        scoreListView.isHidden = false
        popUpView.isHidden = false
        UIView.animate(withDuration: 3) {
            self.visualEffectView.effect = UIBlurEffect(style: .regular)
        }
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
        optionsButton.isHidden = false
        return viewToShare
    }
}
