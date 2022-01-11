//
//  PageView.swift
//  LCPageView
//
//  Created by L63 on 2021/12/7.
// 标题和页面联动的

import UIKit
@objcMembers
public class PageView: UIView {
    fileprivate let titles: [String]
    fileprivate let childs: [UIViewController]
    fileprivate let parentVc: UIViewController
    fileprivate let config: PageTitleConfig
    fileprivate var titleView: PageTitleView!
    fileprivate var contentView: PageContentView!
    
    public init(frame: CGRect,titles: [String],
                childs: [UIViewController],
                parentVC: UIViewController,
                config:PageTitleConfig) {
        self.titles = titles
        self.childs = childs
        self.parentVc = parentVC
        self.config = config
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - setupUI
extension PageView {
    
    fileprivate func setupUI() {
        setupTitleView()
        setupContentView()
        
        
    }
    private func setupTitleView() {
        titleView = PageTitleView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height:config.titleH), titles: titles, config: config)
        addSubview(titleView)
        titleView.delegate = self
        
    }
    private func setupContentView() {
        contentView = PageContentView(frame: CGRect(x: 0, y: config.titleH, width: self.bounds.width, height: self.bounds.height - config.titleH),childs: childs,parentVc: parentVc)
        addSubview(contentView)
        contentView.delegate = self
    }
    
}
///MARK: - PageTitleViewDelegate
extension PageView: PageTitleViewDelegate {
    public func pageTitleView(_ titleView: PageTitleView, didSelect index: Int) {
        contentView.scrollToIdx(index: index)
    }
    
    
}
///MARK: - PageContentViewDelegates
extension PageView: PageContentViewDelegate {
    public func pageContenView(_ pageContent: PageContentView, endScroll index: Int) {
        titleView.selectOneTitle(idx: index)
    }
    
    public func pageContenView(_ pageContent: PageContentView, sourceIdx: Int, targetIdx: Int, progress: CGFloat) {
        titleView.selectTitle(sourceIdx: sourceIdx, targetIdx: targetIdx, progress: progress)
    }
    
    
}
