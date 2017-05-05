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

class PoetsVS: ASViewController<ASCollectionNode>, ASCollectionDataSource {
    
    var poets: JSON?
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        let collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(node: collectionNode)
        collectionNode.backgroundColor = UIColor.white
        collectionNode.registerSupplementaryNode(ofKind: UICollectionElementKindSectionHeader)

        _ = GanjoorProvider.requestPromise(target: Ganjoor.poets).then { (poets) -> Void in
            self.poets = poets
            collectionNode.dataSource = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: CollectionNodeDataSource
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { () -> ASCellNode in
            let rtl = NSMutableParagraphStyle()
            rtl.alignment = .right
            let textNode = ASTextCellNode(attributes: [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20), NSForegroundColorAttributeName: #colorLiteral(red: 0.1773044467, green: 0.1990784109, blue: 0.2371648252, alpha: 1), NSParagraphStyleAttributeName: rtl], insets: UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width * 0.05, bottom: 0, right: UIScreen.main.bounds.width * 0.05))
            textNode.text = (self.poets?[indexPath.row]["name"].stringValue)!
            textNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width - 1, height: 40)
            return textNode
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        let rtl = NSMutableParagraphStyle()
        rtl.alignment = .right
        let textNode = ASTextCellNode(attributes: [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 40), NSForegroundColorAttributeName: #colorLiteral(red: 0.1773044467, green: 0.1990784109, blue: 0.2371648252, alpha: 1), NSParagraphStyleAttributeName: rtl], insets: UIEdgeInsets(top: 20, left: UIScreen.main.bounds.width * 0.05, bottom: 20, right: UIScreen.main.bounds.width * 0.05))
        textNode.text = "شاعرها"
        return textNode
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        if poets != nil{
            return poets!.count
        }
        return 0
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
}
