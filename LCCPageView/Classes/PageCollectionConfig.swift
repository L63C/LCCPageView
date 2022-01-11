//
//  PageCollectionConfig.swift
//  LCPageView
//
//  Created by L63 on 2021/12/8.
//

import UIKit

public class PageCollectionConfig: NSObject {
    public  var titleConfig: PageTitleConfig = PageTitleConfig()
    public var pageCtlH: CGFloat = 30
    public var titleInTop: Bool = true
    
    public var pageCtlTintColor: UIColor = UIColor.gray
    public var pageCtlCurrentColor: UIColor = UIColor.blue
}
