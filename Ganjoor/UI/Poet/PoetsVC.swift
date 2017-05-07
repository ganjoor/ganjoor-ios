//
//  File.swift
//  Ganjoor
//
//  Created by Farzad Nazifi on 3/13/17.
//  Copyright © 2017 boon. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import SwiftyJSON

class PoetsVS: ASViewController<ASCollectionNode>, ASCollectionDataSource, ASCollectionDelegate {
    
    var poets = [Poet]()
    var needsMoreData = true
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(node: collectionNode)
        
        collectionNode.backgroundColor = UIColor.white
        collectionNode.registerSupplementaryNode(ofKind: UICollectionElementKindSectionHeader)
        collectionNode.delegate = self
        collectionNode.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { () -> ASCellNode in
            return SelfSizedCell(text: self.poets[indexPath.row].name, font: UIFont.vazirFont(weight: .regular, size: 20), color: #colorLiteral(red: 0.1773044467, green: 0.1990784109, blue: 0.2371648252, alpha: 1), insets: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30), alignment: .right, isUnderlined: true)
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRangeMake(CGSize(width: collectionNode.frame.width, height: 0), CGSize(width: collectionNode.frame.width, height: CGFloat.greatestFiniteMagnitude))
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        return SelfSizedCell(text: "شاعرها", font: UIFont.vazirFont(weight: .bold, size: 40), color: #colorLiteral(red: 0.1773044467, green: 0.1990784109, blue: 0.2371648252, alpha: 1), insets: UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30), alignment: .right, isUnderlined: false)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, sizeRangeForHeaderInSection section: Int) -> ASSizeRange {
        return ASSizeRangeMake(CGSize(width: collectionNode.frame.width, height: 0), CGSize(width: collectionNode.frame.width, height: CGFloat.greatestFiniteMagnitude))
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        _ = GanjoorProvider.requestPromise(target: .poets(offset: poets.count)).then { (poets) -> Void in
            let newDataSet = poets["poets"].arrayValue.map({ (obj) -> Poet in
                return Poet(jsonData: obj)!
            })
            
            if newDataSet.count > 0 {
                self.poets.insert(contentsOf: newDataSet, at: self.poets.count)
                let indexRange = (self.poets.count - newDataSet.count..<self.poets.count)
                let indexPaths = indexRange.map { IndexPath(row: $0, section: 0) }
                collectionNode.insertItems(at: indexPaths)
            }else{
                self.needsMoreData = false
            }
            context.completeBatchFetching(true)
        }
    }
    
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        return needsMoreData
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let vc = CategoriesVC(poeitId: self.poets[indexPath.row].id, poetName: self.poets[indexPath.row].name)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return poets.count
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
}
