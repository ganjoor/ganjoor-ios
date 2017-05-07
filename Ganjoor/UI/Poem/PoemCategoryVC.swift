//
//  PoemVC.swift
//  Ganjoor
//
//  Created by Farzad Nazifi on 3/15/17.
//  Copyright © 2017 boon. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import SwiftyJSON

class PoemCategoryVC: ASViewController<ASCollectionNode>, ASCollectionDataSource, ASCollectionDelegate {
    
    var poems = [Poem]()
    var categoryName = ""
    
    init(categoryID: Int, categoryName: String) {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(node: collectionNode)
        collectionNode.backgroundColor = UIColor.white
        collectionNode.registerSupplementaryNode(ofKind: UICollectionElementKindSectionHeader)
        collectionNode.delegate = self
        
        self.categoryName = categoryName
            
        _ = GanjoorProvider.requestPromise(target: Ganjoor.poemByCategory(id: categoryID)).then { (poems) -> Void in
            self.poems = poems["poems"].arrayValue.map({ (obj) -> Poem in
                return Poem(jsonData: obj)!
            })
            collectionNode.dataSource = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { () -> ASCellNode in
            return SelfSizedCell(text: self.poems[indexPath.row].title, font: UIFont.vazirFont(weight: .regular, size: 20), color: #colorLiteral(red: 0.1773044467, green: 0.1990784109, blue: 0.2371648252, alpha: 1), insets: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30), alignment: .right, isUnderlined: true)
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRangeMake(CGSize(width: collectionNode.frame.width, height: 0), CGSize(width: collectionNode.frame.width, height: CGFloat.greatestFiniteMagnitude))
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        return SelfSizedCell(text: categoryName, font: UIFont.vazirFont(weight: .bold, size: 40), color: #colorLiteral(red: 0.1773044467, green: 0.1990784109, blue: 0.2371648252, alpha: 1), insets: UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30), alignment: .right, isUnderlined: false)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, sizeRangeForHeaderInSection section: Int) -> ASSizeRange {
        return ASSizeRangeMake(CGSize(width: collectionNode.frame.width, height: 0), CGSize(width: collectionNode.frame.width, height: CGFloat.greatestFiniteMagnitude))
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return poems.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let vc = VerseVC(poemID: self.poems[indexPath.row].id, poemTitle: self.poems[indexPath.row].title)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
}
