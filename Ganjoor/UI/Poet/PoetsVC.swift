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
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        let collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(node: collectionNode)
        collectionNode.backgroundColor = UIColor.white
        collectionNode.registerSupplementaryNode(ofKind: UICollectionElementKindSectionHeader)
        collectionNode.delegate = self
        
        _ = GanjoorProvider.requestPromise(target: .poets(offset: 0)).then { (poets) -> Void in
            self.poets = poets["poets"].arrayValue.map({ (obj) -> Poet in
                return Poet(jsonData: obj)!
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
            let textNode = ASTextCellNode(attributes: [
                NSFontAttributeName: UIFont.vazirFont(weight: .regular, size: 20), NSForegroundColorAttributeName: #colorLiteral(red: 0.1773044467, green: 0.1990784109, blue: 0.2371648252, alpha: 1), NSParagraphStyleAttributeName: rtl], insets: UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width * 0.05, bottom: 0, right: UIScreen.main.bounds.width * 0.05))
            textNode.text = self.poets[indexPath.row].name
            textNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 1, height: 40)
            return textNode
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        let rtl = NSMutableParagraphStyle()
        rtl.alignment = .right
        let textNode = ASTextCellNode(attributes: [
            NSFontAttributeName: UIFont.vazirFont(weight: .bold, size: 40), NSForegroundColorAttributeName: #colorLiteral(red: 0.1773044467, green: 0.1990784109, blue: 0.2371648252, alpha: 1), NSParagraphStyleAttributeName: rtl], insets: UIEdgeInsets(top: 20, left: UIScreen.main.bounds.width * 0.05, bottom: 20, right: UIScreen.main.bounds.width * 0.05))
        textNode.text = "شاعرها"
        return textNode
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let vc = CategoriesVC(poeitId: self.poets[indexPath.row].id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return poets.count
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
}
