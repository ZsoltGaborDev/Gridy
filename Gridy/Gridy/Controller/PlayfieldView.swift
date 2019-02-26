//
//  PlayfieldView.swift
//  Gridy
//
//  Created by zsolt on 31/01/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit
import Foundation
import Photos
import MobileCoreServices

class PlayfieldView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDropDelegate, UICollectionViewDragDelegate {
    
    
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBAction func newGameAction(_ sender: Any) {
    
    }
    
    var toReceive = [UIImage]()
    var collectionOne = [UIImage]()
    var collectionTwo = [UIImage]()
    
//    func setup() {
//        let puzzleImageWidth = (puzzleContainerView.frame.size.width - 30) / 4
//        let puzzleImageLayout = puzzleImage.collectionViewLayout as! UICollectionViewFlowLayout
//        puzzleImageLayout.itemSize = CGSize(width: puzzleImageWidth, height: puzzleImageWidth)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionOne = toReceive
        collectionOne.shuffle()
        
        collectionView1.dragDelegate = self
        collectionView2.dragDelegate = self

        collectionView1.dragInteractionEnabled = true
        collectionView2.dragInteractionEnabled = true

        collectionView1.dropDelegate = self
        collectionView2.dropDelegate = self

        collectionView1.dataSource = self
        collectionView2.dataSource = self
        print(collectionTwo.count)
    }
    
    //number of views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.collectionView1 ? self.collectionOne.count : self.collectionTwo.count
    }
    //populate views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView1.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCell
        cell.myImageView.image = collectionOne[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.collectionOne[indexPath.row]
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    

    // MARK: - UICollectionViewDropDelegate METHODS
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView === collectionView1 || collectionView === collectionView2 {
            print(" is moving !!")
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            print("something went wrong or wrong place to drop!")
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath
        {
            destinationIndexPath = indexPath
        }
        else
        {
            // Get last index path of collection view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation
        {
        case .move:
            //Add the code to reorder items
            if collectionView == collectionView1 {
                let items = coordinator.items
                if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
                {
                    var dIndexPath = destinationIndexPath
                    if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
                    {
                        dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
                    }
                    collectionView.performBatchUpdates({
                        self.collectionOne.remove(at: sourceIndexPath.row)
                        print(sourceIndexPath.row)
                        self.collectionOne.insert(item.dragItem.localObject as! UIImage, at: dIndexPath.row)
                        print(dIndexPath.row)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        print(sourceIndexPath)
                        collectionView.insertItems(at: [dIndexPath])
                        print(dIndexPath)
                    })
                coordinator.drop(item.dragItem, toItemAt: dIndexPath)
                }
            } else {
                if collectionView == collectionView2 {
                    let items = coordinator.items
                    print("number of items: \(items.count)") // console-check if the item exist
                    let sourceIndexPath = items.first?.sourceIndexPath // the problem is that items.first?.sourceIndexPath is nil :(
                    let dIndexPath = destinationIndexPath
                    collectionView.performBatchUpdates({
                        self.collectionTwo.insert(items.first!.dragItem.localObject as! UIImage, at: dIndexPath.row)
                        print("dIndexPath.row : \(dIndexPath.row)")
                        //self.collectionOne.remove(at: sourceIndexPath!.row)
                        //print(sourceIndexPath!.row)
                        collectionView.insertItems(at: [dIndexPath])
                        print(dIndexPath)
                        //collectionView1.deleteItems(at: [sourceIndexPath!])
                        //print(sourceIndexPath!)
                    })
                    coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
                }
            }
            break
        default:
            return
        }
    }
}

