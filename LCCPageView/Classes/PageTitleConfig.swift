//
//  PageTitleConfig.swift
//  LCPageView
//
//  Created by L63 on 2021/12/7.
//

import UIKit

@objcMembers
public class PageTitleConfig: NSObject {
    public var titleH: CGFloat = 44
    public var bgColor: UIColor = .white
    
    public var normalFont: UIFont = UIFont.systemFont(ofSize: 16)
    public var selectFont: UIFont = UIFont.systemFont(ofSize: 16)
    
    public var normalColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    public var selectColor: UIColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
    
    public var scrollable: Bool = false
    public var margin: CGFloat = 10
    
    public var needGradient: Bool = true
    
    public var needShowLine: Bool = true
    public var lineH: CGFloat = 5
    public var lineColor: UIColor = .red
    public var lineAnimate: Bool = false
}
