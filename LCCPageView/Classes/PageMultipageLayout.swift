//
//  PageMultipageLayout.swift
//  LCPageView
//
//  Created by L63 on 2021/12/8.
//

import UIKit
public protocol PageMultipageLayoutDataSource: AnyObject {
    /// 该分组的元素分为几列
    func multipageLayoutColumn(at section:Int) -> Int
    /// 该分组的元素分为几行
    func multipageLayoutRow(at section:Int) -> Int
}
public class PageMultipageLayout: UICollectionViewFlowLayout {
    public weak var dataSource: PageMultipageLayoutDataSource?
    public var column: Int = 4
    public var row: Int = 2
    fileprivate lazy var attributesArr: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    /// 已经计算过的页面数
    fileprivate var maxWidth: CGFloat = 0
    
}
extension PageMultipageLayout {
    public override func prepare() {
        super.prepare()
        /// 总共有多少个section
        let sectionNumber = collectionView!.numberOfSections
        var prePageNumber: Int = 0
        attributesArr.removeAll()
        for section in 0..<sectionNumber {
            /// 当前section 有多少个item
            let itemNumber = collectionView!.numberOfItems(inSection: section)
            // 当前section 是几行几列分布
            let cColumn = dataSource?.multipageLayoutColumn(at: section) ?? column
            let cRow = dataSource?.multipageLayoutRow(at: section) ?? row
            /// 当前分组多有有多少个item
            let elementCount = cColumn * cRow
            
            for item in 0..<itemNumber {
                
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let pageInSection = item / elementCount // item在当前section 的第几页
                let indexInPage = item % elementCount // item 在当前页面的第几个
                
                let rowInPage = indexInPage / cColumn // item 在当前页面的第几行
                let columnInpage = indexInPage % cColumn // item 在当前页面的第几列
                
                let w: CGFloat = (collectionView!.bounds.width - sectionInset.right - sectionInset.left - CGFloat(cColumn - 1) * minimumInteritemSpacing) / CGFloat(cColumn)
                let h: CGFloat = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - CGFloat(cRow - 1) * minimumLineSpacing) / CGFloat(cRow)
                let x: CGFloat = CGFloat(prePageNumber + pageInSection) * collectionView!.bounds.width + sectionInset.left + (minimumInteritemSpacing + w) * CGFloat(columnInpage)
                let y: CGFloat = sectionInset.top + (minimumLineSpacing + h) * CGFloat(rowInPage)
                attributes.frame = CGRect(x: x, y: y, width: w, height: h)
                print(attributes.frame)
                attributesArr.append(attributes)
            }
            prePageNumber += (itemNumber - 1) / elementCount + 1
        }
        maxWidth = CGFloat(prePageNumber) * collectionView!.bounds.width
    }
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        attributesArr
    }
    public override var collectionViewContentSize: CGSize {
       let contentSize = CGSize(width: maxWidth, height: 0)
        print(contentSize)
        return contentSize
    }
}
///MARK: - public methods
extension PageMultipageLayout {
    /// 当前分组元素的元素个数
    func itemCountInSection(section: Int) -> Int {
        let cColumn = dataSource?.multipageLayoutColumn(at: section) ?? column
        let cRow = dataSource?.multipageLayoutRow(at: section) ?? row
        /// 当前分组多有有多少个item
        let elementCount = cColumn * cRow
        return elementCount
    }
}
