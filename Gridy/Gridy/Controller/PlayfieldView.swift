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
    @IBOutlet weak var scoreLabel: UILabel!
    
    var toReceive = [UIImage]()
    var collectionOne = [UIImage]()
    var collectionTwo = [UIImage]()
    var fixedImages = [UIImage].init()
    let frame = UIView()
    var moves: Int = 0
    
    
//    func setup() {
//        let puzzleImageWidth = (puzzleContainerView.frame.size.width - 30) / 4
//        let puzzleImageLayout = puzzleImage.collectionViewLayout as! UICollectionViewFlowLayout
//        puzzleImageLayout.itemSize = CGSize(width: puzzleImageWidth, height: puzzleImageWidth)
//    }
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
                cell.layer.borderColor = UIColor(red: 243/255, green: 233/255, blue: 210/255, alpha: 1).cgColor
                cell.layer.borderWidth = 1
                cell.backgroundColor = .white
                let imageWidth = collectionView1.frame.size.width / 7
                let imageLayout = collectionView1.collectionViewLayout as! UICollectionViewFlowLayout
                imageLayout.itemSize = CGSize(width: imageWidth, height: imageWidth)
            } else {
                // check if the image is dropped in the correct place or not. To make the bonus request, here we could extract the correct and wrong moves separately and report a different, alternative scoring algorithm.
                let blank = fixedImages.first
                collectionTwo.append(blank!) // blank image need for the whole CV
                cell.myImageView.image = collectionTwo[indexPath.item]
                if collectionTwo[indexPath.item] === toReceive[indexPath.item] {
                    print("right place!")
                    cell.myImageView.isHidden = false
                    moves += 1
                }else {
                    print("wrong place!")
                    cell.myImageView.isHidden = false
                    moves += 1
                    
                }
                cell.layer.borderColor = UIColor(red: 243/255, green: 233/255, blue: 210/255, alpha: 1).cgColor
                cell.layer.borderWidth = 1
                cell.backgroundColor = .white
                let imageWidth = collectionView2.frame.size.width / 4
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
    func collectionView(_ collectionView: UICollectionView, canHandle
        session: UIDropSession) -> Bool {
        
        return session.hasItemsConforming(toTypeIdentifiers:
            [kUTTypeImage as String])
    }
    // MARK: - UICollectionViewDropDelegate METHODS
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView === self.collectionView1{
            if collectionView.hasActiveDrag{
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            } else {
                return UICollectionViewDropProposal(operation: .forbidden)
            }
        } else if collectionView == self.collectionView2 {
            if collectionView.hasActiveDrag {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            } else {
                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            }
        } else if destinationIndexPath?.isEmpty ?? true {
            return UICollectionViewDropProposal(operation: .cancel, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
    //setup the drop proposals ... (the cancel proposal is never active, i wanted to call it when the image is draged and dropped out from any collectionview, and the desired result : image should be reloaded always in the 1st collectionview)
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath
        {
            destinationIndexPath = indexPath
        }
        else
        {
            // Get last index path of table view.
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
        case .copy:
            copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            print("copying!")
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
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
        {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
            {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) + 1
            } else if dIndexPath.row >= collectionView.numberOfItems(inSection: 1) {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            collectionView.performBatchUpdates({
                if collectionView === self.collectionView2 {
                    self.collectionTwo.remove(at: sourceIndexPath.row)
                    self.collectionTwo.insert(item.dragItem.localObject as! UIImage, at: dIndexPath.row)
                } else {
                    self.collectionOne.remove(at: sourceIndexPath.row)
                    self.collectionOne.insert(item.dragItem.localObject as! UIImage, at: dIndexPath.row)
                }
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [dIndexPath])
            })
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        }
    }
    /// This method copies a cell from source indexPath in 1st collection view to destination indexPath in 2nd collection view. It works for multiple items.
    ///
    /// - Parameters:
    ///   - coordinator: coordinator obtained from performDropWith: UICollectionViewDropDelegate method
    ///   - destinationIndexPath: indexpath of the collection view where the user drops the element
    ///   - collectionView: collectionView in which reordering needs to be done.
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for (index, item) in coordinator.items.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                if collectionView === collectionView2 {
                    self.collectionTwo.insert(item.dragItem.localObject as! UIImage, at: indexPath.row)
                    collectionView1.cellForItem(at: indexPath)?.isHidden = true
                } else {
                    self.collectionOne.insert(item.dragItem.localObject as! UIImage, at: indexPath.row)
                }
                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
        })
    }
    func setupScore(moves:Int) -> Int {
        var score: Int = 0
        score += moves
        return score
    }
    // the following code it's never used, becuase i don't know how to setup the condition to activate it in "dropSessionDidUpdate" function. This should redo visible the hidden image in 1st collectionwiew as soon the same image is draged out from grid from teh second collectionview. (resumed: as soon canceled the image from 2nd collectionview, has to be reloaded in the 1st one...)
    private func cancelItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
        {
            collectionView.performBatchUpdates({
                if collectionView === self.collectionView2 {
                    self.collectionTwo.remove(at: sourceIndexPath.row)
                }
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView1.cellForItem(at: sourceIndexPath)?.isHidden = false
            })
        }        
    }
    //block from drag the last 2 cells from 1st collectionview
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if proposedIndexPath.row == collectionOne.count - 2 ||   proposedIndexPath.row == collectionOne.count - 1{
            return IndexPath(row: 1, section: 0)
        }
        return proposedIndexPath
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

