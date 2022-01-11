//
//  PageCollectionView.swift
//  LCPageView
//
//  Created by L63 on 2021/12/8.
// 表情键盘功能

import UIKit

public protocol PageCollectionViewDataSource: AnyObject{
    func pageCollectionNumberOfSections(pageCollection: PageCollectionView, in collectionView: UICollectionView) -> Int
    func pageCollection(pageCollection: PageCollectionView,_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    
    func pageCollection(pageCollection: PageCollectionView,_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}




public class PageCollectionView: UIView {
    public    weak var dataSource: PageCollectionViewDataSource?
    public  let titles: [String]
    public  let config: PageCollectionConfig
    public  let layout: PageMultipageLayout
    var titleView: PageTitleView!
    fileprivate var collection: UICollectionView!
    fileprivate var pageCtl: UIPageControl!
    fileprivate var currentIdx: IndexPath = IndexPath(item: 0, section: 0)
    
   public init(frame: CGRect,
         titles: [String],
         config:PageCollectionConfig,
         layout: PageMultipageLayout) {
        self.titles = titles
        self.config = config
        self.layout = layout
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension PageCollectionView {
    fileprivate func setupUI() {
        var titleViewFrame: CGRect
        var collectionFrame: CGRect
        var pageCtlFrame: CGRect
        let titleH = config.titleConfig.titleH
        let pageCtlH = config.pageCtlH
        if config.titleInTop {
            titleViewFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: titleH)
            collectionFrame = CGRect(x: 0, y: titleViewFrame.maxY, width: self.bounds.width, height: self.bounds.height - titleH - pageCtlH)
            pageCtlFrame = CGRect(x: 0, y: collectionFrame.maxY, width: bounds.width, height: pageCtlH)
        }else {
            collectionFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - titleH - pageCtlH)
            pageCtlFrame = CGRect(x: 0, y: collectionFrame.maxY, width: bounds.width, height: pageCtlH)
            titleViewFrame = CGRect(x: 0, y: pageCtlFrame.maxY, width: bounds.width, height: titleH)
        }
        
        collection = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        collection.bounces = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        addSubview(collection)
        titleView = PageTitleView(frame: titleViewFrame, titles: titles, config: config.titleConfig)
        addSubview(titleView)
        titleView.delegate = self
        pageCtl = UIPageControl(frame: pageCtlFrame)
        addSubview(pageCtl)
        pageCtl.currentPageIndicatorTintColor = config.pageCtlCurrentColor
        pageCtl.pageIndicatorTintColor = config.pageCtlTintColor
        
    }
}
///MARK: - public methods
extension PageCollectionView {
    open func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collection.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    open func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        collection.register(nib, forCellWithReuseIdentifier: identifier)
    }
}
///MARK: - private methods
extension PageCollectionView {
    fileprivate func updatePageCtl() {
        let point = CGPoint(x: collection.contentOffset.x + layout.sectionInset.left + 1, y: collection.contentOffset.y + layout.sectionInset.top + 1)
        guard let idx = collection.indexPathForItem(at: point) else {
            return
        }
        if idx != currentIdx {
            let itemCount = layout.itemCountInSection(section: idx.section)
            if currentIdx.section != idx.section{
                /// 更新总页数
                let items = collection.numberOfItems(inSection: idx.section)
                pageCtl.numberOfPages = (items - 1) / itemCount + 1
                titleView.selectOneTitle(idx: idx.section)
            }
            
            pageCtl.currentPage = idx.item / itemCount
            currentIdx = idx
        }
        
    }
}
///MARK: - UICollectionViewDelegate & UICollectionViewDataSources
extension PageCollectionView: UICollectionViewDelegate,UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
       dataSource?.pageCollectionNumberOfSections(pageCollection: self, in: collectionView) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = dataSource?.pageCollection(pageCollection: self, collectionView, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            let itemCount = layout.itemCountInSection(section: section)
            pageCtl.numberOfPages = (items - 1) / itemCount + 1
        }
       
        
        return items
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      dataSource!.pageCollection(pageCollection: self, collection, cellForItemAt: indexPath)
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updatePageCtl()
    }
}
///MARK: - PageTitleViewDelegate
extension PageCollectionView: PageTitleViewDelegate {
    public func pageTitleView(_ titleView: PageTitleView, didSelect index: Int) {
        collection.scrollToItem(at: IndexPath(item: 0, section: index), at: .left, animated: false)
        updatePageCtl()
    }
    
    
}
