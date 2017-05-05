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
    
    init(poeitId: Int) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        let collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(node: collectionNode)
        collectionNode.backgroundColor = UIColor.white
        collectionNode.registerSupplementaryNode(ofKind: UICollectionElementKindSectionHeader)
        collectionNode.delegate = self
        
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
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { () -> ASCellNode in
            let rtl = NSMutableParagraphStyle()
            rtl.alignment = .right
            rtl.lineBreakMode = .byTruncatingMiddle
            let textNode = ASTextCellNode(attributes: [
                NSFontAttributeName: UIFont.vazirFont(weight: .regular, size: 20), NSForegroundColorAttributeName: #colorLiteral(red: 0.1773044467, green: 0.1990784109, blue: 0.2371648252, alpha: 1), NSParagraphStyleAttributeName: rtl], insets: UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width * 0.05, bottom: 0, right: UIScreen.main.bounds.width * 0.1))
            textNode.text = self.categories[indexPath.row].name
            textNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 1, height: 40)
            return textNode
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        let rtl = NSMutableParagraphStyle()
        rtl.alignment = .right
        let textNode = ASTextCellNode(attributes: [
            NSFontAttributeName: UIFont.vazirFont(weight: .bold, size: 40), NSForegroundColorAttributeName: #colorLiteral(red: 0.1773044467, green: 0.1990784109, blue: 0.2371648252, alpha: 1), NSParagraphStyleAttributeName: rtl], insets: UIEdgeInsets(top: 20, left: UIScreen.main.bounds.width * 0.05, bottom: 20, right: UIScreen.main.bounds.width * 0.05))
        textNode.text = self.categories[indexPath.row].name
        return textNode
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
