//
//  Constants.swift
//  RBTreeUI
//
//  Created by LiLi Kazine on 2019/3/5.
//  Copyright © 2019 LiLi Kazine. All rights reserved.
//

import UIKit

class Colors {
    
    static let red = hex2Color(hex: "cf3030")!
    static let red_light = hex2Color(hex: "f67280")!
    static let blue = hex2Color(hex: "35477d")!
    static let black = hex2Color(hex: "141414")!
    static let orange = hex2Color(hex: "e88a1a")!
    static let grey = hex2Color(hex: "d9d9d9")!
    
    static func hex2Color(hex val: String) -> UIColor? {
        if val.count != 6 {
            return nil
        }
        let vals: [String] = [val.substring(include: 0, nonclude: 2), val.substring(include: 2, nonclude: 4), val.substring(include: 4, nonclude: 6)]
        if let decR = UInt8(vals[0], radix: 16), let decG = UInt8(vals[1], radix: 16), let decB = UInt8(vals[2], radix: 16) {
            return UIColor(red: CGFloat(decR)/255.0, green: CGFloat(decG)/255.0, blue: CGFloat(decB)/255.0, alpha: 1.0)
        } else {
            return nil
        }
    }
    
}

extension String {
    func substring(include start: Int, nonclude end: Int) -> String {
        return String(self[String.Index(encodedOffset: start)..<String.Index(encodedOffset: end)])
    }
}
