//
//  UIColor+Extension.swift
//  BCTalk
//
//  Created by L63 on 2021/12/6.
//

import Foundation
import UIKit

extension UIColor {
    
   public convenience init(r:CGFloat,g:CGFloat,b:CGFloat ,alpha:CGFloat = 1.0){
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
   public convenience init?(hex: String){
        guard hex.count >= 6 else {
            return nil
        }
        let tempHex = (hex as NSString).substring(from: hex.count-6)
        var range = NSRange(location: 0, length: 2)
        let rHex = (tempHex as NSString).substring(with: range)
        range.location = 2
        let gHex = (tempHex as NSString).substring(with: range)
        range.location = 4
        let bHex = (tempHex as NSString).substring(with: range)
        
        var r: UInt64 = 0,g: UInt64 = 0,b:UInt64 = 0
        
        Scanner(string: rHex).scanHexInt64(&r)
        Scanner(string: gHex).scanHexInt64(&g)
        Scanner(string: bHex).scanHexInt64(&b)
        self.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
    }
    public class func  randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)),
                       g: CGFloat(arc4random_uniform(256)),
                       b: CGFloat(arc4random_uniform(256)))
    }
    
    
}
