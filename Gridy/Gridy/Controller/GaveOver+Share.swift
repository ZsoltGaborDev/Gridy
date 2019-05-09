//
//  Playfield+Share.swift
//  Gridy
//
//  Created by zsolt on 20/04/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit

extension GameOverView {
    //MARK: Sharing options
    func displaySharingOptions() {
        //prepare content to share
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.effect = nil
            self.optionsButton.alpha = 0
            self.scoreListView.alpha = 1
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
    //MARK: Prepare image for share. 
    func composeCreationImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let viewToShare = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        optionsButton.alpha = 1
        return viewToShare
    }
}
