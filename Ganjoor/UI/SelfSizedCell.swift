//
//  Cell.swift
//  Ganjoor
//
//  Created by Farzad Nazifi on 5/7/17.
//  Copyright © 2017 boon. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class SelfSizedCell: ASCellNode {
    
    let textNode = ASTextNode()
    let insets: UIEdgeInsets
    
    init(text: String, font: UIFont, color: UIColor, insets: UIEdgeInsets, alignment: NSTextAlignment) {
        self.insets = insets
        super.init()
        addSubnode(textNode)
        
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        
        textNode.attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: style])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: insets, child: textNode)
    }
}
