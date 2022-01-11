//
//  PageContentView.swift
//  LCPageView
//
//  Created by L63 on 2021/12/7.
//

import UIKit
public protocol PageContentViewDelegate: AnyObject{
    func pageContenView(_ pageContent:PageContentView,endScroll index:Int)
    func pageContenView(_ pageContent:PageContentView,sourceIdx:Int,targetIdx:Int,progress:CGFloat)
}

private let kPageContentCellID = "kPageContentCellID"
public class PageContentView: UIView {
    fileprivate let childs: [UIViewController]
    fileprivate let parentVc: UIViewController
    weak var delegate: PageContentViewDelegate?
    private var startOffsetX: CGFloat = 0
    fileprivate var forbidenScroll = false
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.bounds.width, height: self.bounds.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
         
        let collection = UICollectionView(frame: bounds,collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kPageContentCellID)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.bounces = false
        return collection
    }()
    
    public init(frame: CGRect,
                childs: [UIViewController],
                parentVc: UIViewController) {
        self.childs = childs
        self.parentVc = parentVc
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageContentView {
   fileprivate func setupUI() {
        addSubview(collection)
    }
}

extension PageContentView: UICollectionViewDelegate,UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        childs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: kPageContentCellID, for: indexPath)
        for v in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        let view = childs[indexPath.row].view!
        view.frame = cell.contentView.bounds
        cell.contentView.addSubview(view)
        return cell
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        forbidenScroll = false
        startOffsetX = scrollView.contentOffset.x
        
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !forbidenScroll else {
            return
        }
        if !decelerate{
            contentViewEndScroll()
        }else {
            // 禁止用户在减速过程中再次拖动
            collection.isScrollEnabled = false
        }
        
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard !forbidenScroll else {
            return
        }
        contentViewEndScroll()
        collection.isScrollEnabled = true
    }
    func contentViewEndScroll() {
        let idx = collection.contentOffset.x / collection.frame.width
        delegate?.pageContenView(self, endScroll: Int(idx))
    }
    private func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !forbidenScroll else {
            return
        }
        let currentOffsetX = scrollView.contentOffset.x
        var delta: CGFloat = 0
        let sourceIdx = Int(startOffsetX/scrollView.frame.width)
        var targetIdx = 0
        if currentOffsetX > startOffsetX { // 向左滑动
            targetIdx = sourceIdx + 1
            delta = currentOffsetX - startOffsetX
        }else { // 向右滑动
            targetIdx = sourceIdx - 1
            delta = startOffsetX - currentOffsetX
        }
        var progress = delta / scrollView.bounds.width
        if(progress > 1){
            progress = 1
        }
        delegate?.pageContenView(self, sourceIdx: sourceIdx, targetIdx: targetIdx, progress: progress)
    }
}

extension PageContentView {
   public func scrollToIdx(index: Int){
        forbidenScroll = true
        let idx = IndexPath(item: index, section: 0)
        collection.scrollToItem(at: idx, at: .left, animated: false)
    } 
}
