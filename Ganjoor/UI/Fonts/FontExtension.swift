//
//  FontExtension.swift
//  Ganjoor
//
//  Created by Farzad Nazifi on 5/5/17.
//  Copyright © 2017 boon. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    enum vazirWeight: String {
        case regular = "Vazir"
        case bold = "Vazir-Bold"
        case light = "Vazir-Light"
    }
    
    static func vazirFont(weight: vazirWeight, size: CGFloat) -> UIFont {
        return UIFont(name: weight.rawValue, size: size)!
    }
}
