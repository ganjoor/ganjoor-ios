//
//  Categories.swift
//  Ganjoor
//
//  Created by Farzad Nazifi on 3/15/17.
//  Copyright © 2017 boon. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import SwiftyJSON

class CategoriesVC: ASViewController<ASCollectionNode>, ASCollectionDataSource, ASCollectionDelegate {
    
    var categories = [Category]()
    var poetName = ""

    init(poeitId: Int, poetName: String) {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(node: collectionNode)
        collectionNode.backgroundColor = UIColor.white
        collectionNode.registerSupplementaryNode(ofKind: UICollectionElementKindSectionHeader)
        collectionNode.delegate = self
        
        self.poetName = poetName
        
        _ = GanjoorProvider.requestPromise(target: Ganjoor.categoriesByPoet(id: poeitId)).then { (categories) -> Void in
            self.categories = categories["categories"].arrayValue.map({ (obj) -> Category in
                return Category(jsonData: obj)!
            })
            collectionNode.dataSource = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRangeMake(CGSize(width: collectionNode.frame.width, height: 0), CGSize(width: collectionNode.frame.width, height: CGFloat.greatestFiniteMagnitude))
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { () -> ASCellNode in
            return SelfSizedCell(text: self.categories[indexPath.row].name, font: UIFont.vazirFont(weight: .regular, size: 20), color: #colorLiteral(red: 0.1773044467, green: 0.1990784109, blue: 0.2371648252, alpha: 1), insets: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30), alignment: .right, isUnderlined: true)
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        return SelfSizedCell(text: poetName, font: UIFont.vazirFont(weight: .bold, size: 40), color: #colorLiteral(red: 0.1773044467, green: 0.1990784109, blue: 0.2371648252, alpha: 1), insets: UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30), alignment: .right, isUnderlined: false)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, sizeRangeForHeaderInSection section: Int) -> ASSizeRange {
        return ASSizeRangeMake(CGSize(width: collectionNode.frame.width, height: 0), CGSize(width: collectionNode.frame.width, height: CGFloat.greatestFiniteMagnitude))
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let vc = PoemCategoryVC(categoryID: self.categories[indexPath.row].id, categoryName: self.categories[indexPath.row].name)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
}
