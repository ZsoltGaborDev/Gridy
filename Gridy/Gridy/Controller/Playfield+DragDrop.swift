//
//  Playfield+DragDrop.swift
//  Gridy
//
//  Created by zsolt on 28/03/2019.
//  Copyright © 2019 zsolt. All rights reserved.
//

import UIKit

extension PlayfieldView: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let item: UIImage
        let image = collectionOne[indexPath.item]
        if fixedImages.contains(image) {
            return []
        }
        if collectionView == collectionView1 {
            item = image
        } else {
            item = (self.collectionTwo?[indexPath.row])!
        }
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        scoreLabel.text = "\(moves)"
        print(#function)
        let dip: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            dip = indexPath
        } else {
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            dip = IndexPath(row: row, section: section)
        }
        switch coordinator.proposal.operation {
        case .move:
            reorderItems(coordinator: coordinator, destinationIndexPath: dip, collectionView: collectionView)
            print("moving!")
        case .cancel:
            return
        //            cancelItems(coordinator: coordinator, destinationIndexProvider: dip, collectionView: collectionView)
        default:
            return
        }
    }
    
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                        print("\(#function) is called")
                        print("Coordinator: \(coordinator)")
                        print("Destination Index Provider: \(destinationIndexPath.row)")
                        print("Collection View: \(collectionView)")
                if collectionView == self.collectionView2 {
                    if collectionView1.hasActiveDrop && (item.dragItem.localObject as! UIImage) != fixedImages.first {
                        print("doing 1")
                        collectionTwo?.remove(at: sourceIndexPath.row)
                        collectionTwo?.insert(fixedImages.first as! UIImage , at: sourceIndexPath.row)
                        collectionOne.remove(at: destinationIndexPath.row)
                        collectionOne.insert(item.dragItem.localObject as! UIImage, at: destinationIndexPath.row)
                    } else {
                        print("doing 2")
                        collectionTwo?.remove(at: sourceIndexPath.row)
                        collectionTwo?.insert(item.dragItem.localObject as! UIImage, at: destinationIndexPath.row)
                    }
                } else {
                    if collectionView2.hasActiveDrop && (item.dragItem.localObject as! UIImage) != fixedImages.first {
                        print("doing 3")
                        collectionOne.remove(at: sourceIndexPath.row)
                        collectionOne.insert(fixedImages.first!!, at: sourceIndexPath.row)
                        collectionTwo?.remove(at: destinationIndexPath.row)
                        collectionTwo?.insert(item.dragItem.localObject as! UIImage, at: destinationIndexPath.row)
                    } else {
                        print("doing 4")
                        collectionOne.remove(at: sourceIndexPath.row)
                        self.collectionOne.insert(item.dragItem.localObject as! UIImage, at: destinationIndexPath.row)
                    }
                }
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            })
            coordinator.drop(items.first!.dragItem, toItemAt: destinationIndexPath)
        }
    }
    
    
    
//    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexProvider dip: IndexPath, collectionView cv: UICollectionView) {
//        print("\(#function) is called")
//        print("Coordinator: \(coordinator)")
//        print("Destination Index Provider: \(dip)")
//        print("Collection View: \(cv)")
//    }
    
    //    private func cancelItems(coordinator: UICollectionViewDropCoordinator,destinationIndexProvider dip: IndexPath, collectionView cv: UICollectionView) {
    //        print("\(#function) is called")
    //        print("Coordinator: \(coordinator)")
    //        print("Destination Index Provider: \(dip)")
    //        print("Collection View: \(cv)")
    //    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        // Use this to visually clean up and check collection view 2 for right drop path
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}
