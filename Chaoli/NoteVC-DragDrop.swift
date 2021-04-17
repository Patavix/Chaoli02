//
//  NoteVC-DragDrop.swift
//  Chaoli
//
//  Created by 潘涛 on 2021/4/17.
//

import Foundation


extension NoteVC: UICollectionViewDragDelegate{
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
    {
        let dragedphoto = photos[indexPath.item]
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: dragedphoto))
        dragItem.localObject = dragedphoto
        return [dragItem]
        
    }
//若要改变drag时cell的外观，需要实现下面的函数
//    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
//
//    }

}



extension NoteVC: UICollectionViewDropDelegate{
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        if collectionView.hasActiveDrag{
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        if coordinator.proposal.operation == .move,
           let item = coordinator.items.first,
           let sourceIndexPath = item.sourceIndexPath,
           let destinationindexpath = coordinator.destinationIndexPath
        {
            
            collectionView.performBatchUpdates({
                photos.remove(at: sourceIndexPath.item)
                photos.insert(item.dragItem.localObject as! UIImage, at: destinationindexpath.item)
                collectionView.moveItem(at: sourceIndexPath, to: destinationindexpath)
            })
            coordinator.drop(item.dragItem, toItemAt: destinationindexpath)
        }
    }
    
    
}
