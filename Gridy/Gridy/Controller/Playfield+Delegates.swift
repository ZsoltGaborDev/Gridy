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
        return collectionView == self.collectionView1 ? collectionOne.count : collectionTwo.count
    }

    
    //MARK: - Cell For Item At
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCell
        cell.layer.borderColor = UIColor(red: 243/255, green: 233/255, blue: 210/255, alpha: 1).cgColor
        cell.layer.borderWidth = 1
        cell.backgroundColor = .white
        // COLLECTION VIEW 1
        if collectionView == collectionView1 {
            print(indexPath.item)
            print(collectionOne.count - 1)
            cell.myImageView.image = collectionOne[indexPath.item]
            let width = collectionView1.frame.size.width / 7
            let layout = collectionView1.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: width, height: width)
        // COLLECTION VIEW 2
        } else {
            if cell.myImageView.image == fixedImages.first! {
                cell.myImageView.image = collectionTwo[indexPath.item]
            } else {
                cell.myImageView.image = collectionTwo[indexPath.item]
                if collectionTwo[indexPath.item] === toReceive[indexPath.item] {
                    print("right place!")
                    moves += 1
                } else {
                    print("wrong place!")
                    moves += 1
                }
            }
            let width = collectionView2.frame.size.width / 4
            let layout = collectionView2.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: width, height: width)
        }
        return cell
    }
    
    //MARK: - Did Select Item At
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == (collectionOne.count - 1) {
            popUpView.isHidden = false
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.hidePopUpImage), userInfo: nil, repeats: false)
        }
    }
    @objc func hidePopUpImage() {
        popUpView.isHidden = true
    }
}
