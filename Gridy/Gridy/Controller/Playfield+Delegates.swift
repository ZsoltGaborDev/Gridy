//
//  Playfield+Delegates.swift
//  Gridy
//
//  Created by zsolt on 28/03/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit

extension PlayfieldView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Number Of Items In Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.CVOne ? CVOneImages.count : CVTwoImages.count
    }

    
    //MARK: - Cell For Item At
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCell
        cell.layer.borderColor = UIColor(red: 243/255, green: 233/255, blue: 210/255, alpha: 1).cgColor
        cell.layer.borderWidth = 1
        cell.backgroundColor = .white
        // COLLECTION VIEW 1
        if collectionView == CVOne {
            let width = (CVOne.frame.size.width - 30) / 6
            let layout = CVOne.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: width, height: width)
            cell.imageView.image = CVOneImages[indexPath.item]
        // COLLECTION VIEW 2
        } else {
            let width = CVTwo.frame.size.width / 4
            let layout = CVTwo.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: width, height: width)
            cell.imageView.image = CVTwoImages[indexPath.item]
        }
        return cell
    }
    
    //MARK: - Did Select Item At - help button
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == (CVOneImages.count - 1) {
            popUpView.isHidden = false
            popUpView.layer.borderColor = UIColor(red: 243/255, green: 233/255, blue: 210/255, alpha: 1).cgColor
            popUpView.layer.borderWidth = 5
            popUpView.layer.cornerRadius = 15
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.hidePopUpImage), userInfo: nil, repeats: false)
        }
    }
    @objc func hidePopUpImage() {
        popUpView.isHidden = true
    }
    //MARK: Orientation Transition
    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape,
            let layoutOne = CVOne.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = (CVOne.frame.width - 30) / 6
            layoutOne.itemSize = CGSize(width: width, height: width)
            layoutOne.invalidateLayout()
        } else
            if UIDevice.current.orientation.isPortrait,
            let layoutOne = CVOne.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = (CVOne.frame.width - 30) / 6
            layoutOne.itemSize = CGSize(width: width , height: width)
            layoutOne.invalidateLayout()
        }
        if UIDevice.current.orientation.isLandscape,
            let layoutTwo = CVTwo.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = CVTwo.frame.width/4
            layoutTwo.itemSize = CGSize(width: width, height: width)
            layoutTwo.invalidateLayout()
        } else if UIDevice.current.orientation.isPortrait,
            let layoutTwo = CVTwo.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = CVTwo.frame.width/4
            layoutTwo.itemSize = CGSize(width: width , height: width)
            layoutTwo.invalidateLayout()
        }
        CVOne.reloadData()
        CVTwo.reloadData()
    }
}
