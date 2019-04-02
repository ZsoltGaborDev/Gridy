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
            item = (self.collectionTwo[indexPath.row])
        }
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        // Use this to visually clean up and check collection view 2 for right drop path
        if collectionView === collectionView1 || collectionView === collectionView2 {
            return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .forbidden)
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
        switch coordinator.proposal.operation {
//        case .move:
//            reorderItems(coordinator: coordinator, destinationIndexPath: dip, collectionView: collectionView)
//            print("moving!")
        case .cancel:
            return
        //            cancelItems(coordinator: coordinator, destinationIndexProvider: dip, collectionView: collectionView)
        case .copy:
            copyItems(coordinator: coordinator, destinationIndexPath: dip, collectionView: collectionView)
            print("copying")
        default:
            return
        }
    }

    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if collectionView == collectionView1 {
            if collectionView1.hasActiveDrag {
                let items = coordinator.items
                if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath {
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
                    print("doing 1")
                }
            } else {
                let items = coordinator.items
                let dIndexPath = destinationIndexPath
                collectionView.performBatchUpdates({
                    self.collectionOne.insert(items.first!.dragItem.localObject as! UIImage, at: dIndexPath.row)
                    self.collectionTwo.remove(at: dIndexPath.row)
                    collectionView1.insertItems(at: [dIndexPath])
                    collectionView2.deleteItems(at: [dIndexPath])
                    print(dIndexPath)
                })
                coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
                print("doing 2")
            }
        } else {
            if collectionView == collectionView2 {
                if collectionView2.hasActiveDrag {
                    let items = coordinator.items
                    if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
                    {
                        var dIndexPath = destinationIndexPath
                        if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
                        {
                            dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
                        }
                        collectionView.performBatchUpdates({
                            self.collectionTwo.remove(at: sourceIndexPath.row)
                            print(sourceIndexPath.row)
                            self.collectionTwo.insert(item.dragItem.localObject as! UIImage, at: dIndexPath.row)
                            print(dIndexPath.row)
                            collectionView.deleteItems(at: [sourceIndexPath])
                            print(sourceIndexPath)
                            collectionView.insertItems(at: [dIndexPath])
                            print(dIndexPath)
                        })
                        coordinator.drop(item.dragItem, toItemAt: dIndexPath)
                        print("doing 3")
                    }
                } else {
                    let items = coordinator.items
                    let dIndexPath = destinationIndexPath
                    collectionView.performBatchUpdates({
                        self.collectionTwo.insert(items.first!.dragItem.localObject as! UIImage, at: dIndexPath.row)
                        self.collectionOne.remove(at: dIndexPath.row)
                        collectionView2.insertItems(at: [dIndexPath])
                        collectionView1.deleteItems(at: [dIndexPath])
                        print(dIndexPath)
                    })
                    coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
                    print("doing 4")
                }
            }
        }
    }
}
