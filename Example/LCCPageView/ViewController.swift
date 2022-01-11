//
//  ViewController.swift
//  LCPageView
//
//  Created by L63 on 2021/12/7.
//

import UIKit
import LCCPageView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }


}
extension ViewController {
    fileprivate func setupUI() {
//        let titles = ["你好","爱上","颠覆","颠信"]
        let titles = ["你好","阿双方就开始","阿瑟","阿斯顿发","时代","你好","阿双方就开始","阿瑟","阿斯顿发"]
        
        let config = PageTitleConfig()
        config.titleH = 60
        config.bgColor = UIColor.randomColor()
        config.scrollable = true
        config.needShowLine = true
        config.lineAnimate = false
        
        var childs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childs.append(vc)
        }
        
        
        let pageView = PageView(frame: view.bounds, titles: titles, childs: childs, parentVC: self.self, config: config)
        view.addSubview(pageView)
    }
}
