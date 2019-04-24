//
//  Playfield+DragDrop.swift
//  Gridy
//
//  Created by zsolt on 28/03/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit

extension PlayfieldView: UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIDropInteractionDelegate {

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

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
        print(#function)
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
            orderItems(coordinator: coordinator, destinationIndexPath: dip, collectionView: collectionView)
            print("moving!")
        } else if collectionView === CVOne {
            redoItems(coordinator: coordinator, destinationIndexPath: dip, collectionView: collectionView)
        } else {
            return
        }
    }
    private func orderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        let items = coordinator.items
        scoring(moves: moves)
        collectionView.performBatchUpdates({
            let dragItem = items.first!.dragItem.localObject as! UIImage
            if dragItem === toReceive[destinationIndexPath.item] {
                rightMoves += 1
                self.CVTwoImages.insert(items.first!.dragItem.localObject as! UIImage, at: destinationIndexPath.row)
                //self.CVOneImages.remove(at: sourceIndexPath.row)
                CVTwo.insertItems(at: [destinationIndexPath])
                //CVOne.deleteItems(at: [sourceIndexPath])
            }
        })
        collectionView.performBatchUpdates({
            if items.first!.dragItem.localObject as! UIImage === toReceive[destinationIndexPath.item] {
                self.CVTwoImages.remove(at: destinationIndexPath.row + 1)
                //self.CVOneImages.remove(at: dIndexPath.row)
                let nextIndexPath = NSIndexPath(row: destinationIndexPath.row + 1, section: 0)
                CVTwo.deleteItems(at: [nextIndexPath] as [IndexPath])
                //CVOne.deleteItems(at: [dIndexPath])
            } else {
                vibrate()
            }
        })
        coordinator.drop(items.first!.dragItem, toItemAt: destinationIndexPath)
        if rightMoves == CVTwoImages.count {
            performSegue(withIdentifier: "my3rdSegue", sender: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func redoItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
            {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            collectionView.performBatchUpdates({
                self.CVOneImages.remove(at: sourceIndexPath.row)
                print(sourceIndexPath.row)
                self.CVOneImages.insert(item.dragItem.localObject as! UIImage, at: dIndexPath.row)
                print(dIndexPath.row)
                collectionView.deleteItems(at: [sourceIndexPath])
                print(sourceIndexPath)
                collectionView.insertItems(at: [dIndexPath])
                print(dIndexPath)
            })
            coordinator.drop(item.dragItem, toItemAt: dIndexPath)
            print("doing 1")
        }
    
    }
}
