//
//  Playfield+DragDrop.swift
//  Gridy
//
//  Created by zsolt on 28/03/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit

extension PlayfieldView: UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIDropInteractionDelegate {
    
    //MARK: Drag Session
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        self.isSelected = indexPath
        let item: UIImage
        let image = CVOneImages[indexPath.item]
        if (image == fixedImages.last) || (image == fixedImages.first) {
            return []
        }
        if collectionView == CVOne {
            item = image
        } else {
            item = (self.CVTwoImages[indexPath.row])
        }
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    // MARK: Drop Session
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if destinationIndexPath?.row == 16 || destinationIndexPath?.row == 17 {
            return UICollectionViewDropProposal(operation: .forbidden)
        } else if collectionView === CVTwo {
            return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
        } else if collectionView === CVOne && CVTwo.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let dip: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            dip = indexPath
        } else {
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            dip = IndexPath(row: row, section: section)
        }
        if dip.row == 16 || dip.row == 17 {
            return
        }
        if collectionView === CVTwo {
            moveItems(coordinator: coordinator, destinationIndexPath: dip, collectionView: collectionView)
        } else if collectionView === CVOne {
            reorderItems(coordinator: coordinator, destinationIndexPath: dip, collectionView: collectionView)
        } else {
            return
        }
    }
    
    //MARK: drag and drop functions
    private func moveItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        let items = coordinator.items
        scoring(moves: moves)
        collectionView.performBatchUpdates({
            let dragItem = items.first!.dragItem.localObject as! UIImage
            if dragItem === toReceive[destinationIndexPath.item] {
                rightMoves += 1
                self.CVTwoImages.insert(items.first!.dragItem.localObject as! UIImage, at: destinationIndexPath.row)
                CVTwo.insertItems(at: [destinationIndexPath])
                if let selected = isSelected {
                    CVOneImages.remove(at: selected.row)
                    if let temp = UIImage(named: "Blank") {
                        let blank = temp
                        CVOneImages.insert(blank, at: selected.row)
                    }
                    CVOne.reloadData()
                    playSound()
                }
            }
        })
        collectionView.performBatchUpdates({
            if items.first!.dragItem.localObject as! UIImage === toReceive[destinationIndexPath.item] {
                self.CVTwoImages.remove(at: destinationIndexPath.row + 1)
                let nextIndexPath = NSIndexPath(row: destinationIndexPath.row + 1, section: 0)
                CVTwo.deleteItems(at: [nextIndexPath] as [IndexPath])
            } else {
                vibrate()
                print("vibrating...")
            }
        })
        coordinator.drop(items.first!.dragItem, toItemAt: destinationIndexPath)
        if rightMoves == CVTwoImages.count {
            performSegue(withIdentifier: "my3rdSegue", sender: nil)
        }
    }
    
    func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
            {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            collectionView.performBatchUpdates({
                self.CVOneImages.remove(at: sourceIndexPath.row)
                self.CVOneImages.insert(item.dragItem.localObject as! UIImage, at: dIndexPath.row)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [dIndexPath])
            })
            coordinator.drop(item.dragItem, toItemAt: dIndexPath)
        }
        //TODO: redoItems function (from second collection view to teh first one)
    
    }
}
