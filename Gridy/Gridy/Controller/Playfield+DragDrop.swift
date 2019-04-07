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
        
        // Use this to visually clean up and check collection view 2 for right drop path
        if collectionView === CVOne || collectionView === CVTwo {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
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

    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        scoring(moves: moves)
        if collectionView == CVOne {
            if CVOne.hasActiveDrag  {
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
//            } else {
//                let items = coordinator.items
//                let dIndexPath = destinationIndexPath
//                collectionView.performBatchUpdates({
//                    self.CVOneImages.insert(items.first!.dragItem.localObject as! UIImage, at: dIndexPath.row)
//                    self.CVTwoImages.remove(at: dIndexPath.row)
//                    CVOne.insertItems(at: [dIndexPath])
//                    CVTwo.deleteItems(at: [dIndexPath])
//                    print(dIndexPath)
//                })
//                coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
//                print("doing 2")
//            }
        } else {
            if collectionView == CVTwo {
//                if CVTwo.hasActiveDrag {
//                    let items = coordinator.items
//                    if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
//                    {
//                        var dIndexPath = destinationIndexPath
//                        if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
//                        {
//                            dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
//                        }
//                        collectionView.performBatchUpdates({
//                            self.CVTwoImages.remove(at: sourceIndexPath.row)
//                            print(sourceIndexPath.row)
//                            self.CVTwoImages.insert(item.dragItem.localObject as! UIImage, at: dIndexPath.row)
//                            print(dIndexPath.row)
//                            collectionView.deleteItems(at: [sourceIndexPath])
//                            print(sourceIndexPath)
//                            collectionView.insertItems(at: [dIndexPath])
//                            print(dIndexPath)
//                        })
//                        coordinator.drop(item.dragItem, toItemAt: dIndexPath)
//                        print("doing 3")
//                    }
//                } else {
                        let items = coordinator.items
                        let dIndexPath = destinationIndexPath
                        collectionView.performBatchUpdates({
                            let dragItem = items.first!.dragItem.localObject as! UIImage
                            if dragItem === toReceive[dIndexPath.item] {
                                print("it works !!!!")
                                self.CVTwoImages.insert(items.first!.dragItem.localObject as! UIImage, at: dIndexPath.row)
                                //self.CVOneImages.remove(at: sourceIndexPath.row)
                                CVTwo.insertItems(at: [dIndexPath])
                                //CVOne.deleteItems(at: [sourceIndexPath])
                            }
                            print(dIndexPath)
                        })
                        collectionView.performBatchUpdates({
                            if items.first!.dragItem.localObject as! UIImage === toReceive[dIndexPath.item] {
                                print("it works !!!!")
                                self.CVTwoImages.remove(at: dIndexPath.row + 1)
                                //self.CVOneImages.remove(at: dIndexPath.row)
                                let nextIndexPath = NSIndexPath(row: dIndexPath.row + 1, section: 0)
                                CVTwo.deleteItems(at: [nextIndexPath] as [IndexPath])
                                //CVOne.deleteItems(at: [dIndexPath])
                            } else {
                                print("wrong place !!!")
                            }
                            print(dIndexPath)
                        })
                        coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
                        print("doing 4")
//                }
            }
        }
    }
}
