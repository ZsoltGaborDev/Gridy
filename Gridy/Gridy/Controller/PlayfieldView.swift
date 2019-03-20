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
    @IBOutlet weak var cvContainer: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var toReceive = [UIImage]()
    var collectionOne = [UIImage]()
    var collectionTwo = [UIImage]()
    var fixedImages = [UIImage].init()
    let frame = UIView()
    var moves: Int = -16

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionOne = toReceive
        collectionOne.shuffle()
        collectFixedImageSet()
        collectionView1.dragInteractionEnabled = true
        collectionView2.dragInteractionEnabled = true
    }
    //number of views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return collectionView == self.collectionView1 ? collectionOne.count : collectionTwo.count
        // we need 2 extra cells in teh 1st collectionview, one blank and one with the eye that will activate one popup for 2 - 3 second with the whole puzzle image
        return collectionView == self.collectionView1 ? 18 : 16
    }
    //populate views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCell
            if collectionView == collectionView1 {
                collectionOne.append(contentsOf: fixedImages)
                cell.myImageView.image = collectionOne[indexPath.item]
                if (cell.myImageView.image != fixedImages.first!) && (cell.myImageView.image != fixedImages.last) {
                    cell.layer.borderColor = UIColor(red: 243/255, green: 233/255, blue: 210/255, alpha: 1).cgColor
                    cell.layer.borderWidth = 1
                }
                cell.backgroundColor = .white
                let cv1Width = (cvContainer.frame.height / 2 ) - 41
                let imageWidth = cv1Width / 5
                let imageLayout = collectionView1.collectionViewLayout as! UICollectionViewFlowLayout
                imageLayout.itemSize = CGSize(width: imageWidth, height: imageWidth)
            } else {
                let blank = fixedImages.first
                collectionTwo.append(blank!) // blank image need for the whole CV
                cell.myImageView.image = collectionTwo[indexPath.item]
                if collectionTwo[indexPath.item] === toReceive[indexPath.item] {
                    print("right place!")
                    moves += 1
                } else {
                    print("wrong place!")
                    moves += 1     
                }
                cell.layer.borderColor = UIColor(red: 243/255, green: 233/255, blue: 210/255, alpha: 1).cgColor
                cell.layer.borderWidth = 1
                cell.backgroundColor = .white
                let cv2Width = cvContainer.frame.height / 2
                let imageWidth = cv2Width / 3.4
                let imageLayout = collectionView2.collectionViewLayout as! UICollectionViewFlowLayout
                imageLayout.itemSize = CGSize(width: imageWidth, height: imageWidth)
            }
            return cell
    }
    // setup dragItem
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item: UIImage
        if collectionView == collectionView1 {
            item = self.collectionOne[indexPath.row]
        } else {
            item = self.collectionTwo[indexPath.row]
        }
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    // MARK: - UICollectionViewDropDelegate METHODS
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath
        {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of collection view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        switch coordinator.proposal.operation
        {
        case .move:
            reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            print("moving!")
            scoreLabel.text = "\(setupScore(moves: moves))"
            break
        case .cancel:
            cancelItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            print("canceling")
            scoreLabel.text = "\(setupScore(moves: moves))"
            break
        default:
            return
        }
    }
    //MARK: Private Methods
    
    /* This method moves a cell from source indexPath to destination indexPath within the same collection view. It works for only 1 item.
     - Parameters:
       - coordinator: coordinator obtained from performDropWith: UICollectionViewDropDelegate method
       - destinationIndexPath: indexpath of the collection view where the user drops the element
       - collectionView: collectionView in which reordering needs to be done. */
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                if collectionView === self.collectionView2 {
                    if collectionView1.hasActiveDrop && (item.dragItem.localObject as! UIImage) != fixedImages.first {
                        print("doing 1")
                        self.collectionTwo.remove(at: sourceIndexPath.row)
                        self.collectionTwo.insert(fixedImages.first!, at: sourceIndexPath.row)
                        self.collectionOne.remove(at: destinationIndexPath.row)
                        self.collectionOne.insert(item.dragItem.localObject as! UIImage, at: destinationIndexPath.row)
                    } else {
                        print("doing 2")
                        self.collectionTwo.remove(at: sourceIndexPath.row)
                        self.collectionTwo.insert(item.dragItem.localObject as! UIImage, at: destinationIndexPath.row)
                    }
                } else {
                    if collectionView2.hasActiveDrop && (item.dragItem.localObject as! UIImage) != fixedImages.first {
                        print("doing 3")
                        self.collectionOne.remove(at: sourceIndexPath.row)
                        self.collectionOne.insert(fixedImages.first!, at: sourceIndexPath.row)
                        self.collectionTwo.remove(at: destinationIndexPath.row)
                        self.collectionTwo.insert(item.dragItem.localObject as! UIImage, at: destinationIndexPath.row)
                    } else {
                        print("doing 4")
                        self.collectionOne.remove(at: sourceIndexPath.row)
                        self.collectionOne.insert(item.dragItem.localObject as! UIImage, at: destinationIndexPath.row)
                    }
                }
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            })
            coordinator.drop(items.first!.dragItem, toItemAt: destinationIndexPath)
        }
    }
    func setupScore(moves:Int) -> Int {
        var score: Int = 0
        score += moves
        return score
    }
    // the following code it's never used, becuase I don't know how to setup the condition to activate it in "dropSessionDidUpdate" function. This should be the "swipe out of the grid to undo"
    private func cancelItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
        {
            collectionView.performBatchUpdates({
                if collectionView != self.collectionView1 && collectionView != collectionView2 && collectionView2.hasActiveDrag {
                    self.collectionTwo.remove(at: sourceIndexPath.row)
                    self.collectionTwo.insert(fixedImages.first!, at: sourceIndexPath.row)
                    self.collectionOne.insert(item.dragItem.localObject as! UIImage, at: 0)
                }
                collectionView2.deleteItems(at: [sourceIndexPath])
                collectionView1.insertItems(at: [destinationIndexPath])
            })
        }        
    }
    // create the fixed images for the 2 blocked cells of collectionview1
    func collectFixedImageSet() {
        fixedImages.removeAll()
        let imageNames = ["Blank", "Gridy-lookup"]
        for name in imageNames {
            if let image = UIImage.init(named: name) {
                fixedImages.append(image)
            }
        }
    }
}

