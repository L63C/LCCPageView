//
//  CollectionViewTestVC.swift
//  LCPageView
//
//  Created by L63 on 2021/12/8.
//

import UIKit
import LCCPageView

fileprivate let collectionId = "collectionId"
class CollectionViewTestVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}
extension CollectionViewTestVC {
    func setupUI(){
        let titles = ["你好","哈哈","我是","定档"]
        let config = PageCollectionConfig()
        config.titleInTop = false
        let layout = PageMultipageLayout()
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 20, right: 5)
        layout.column = 7
        layout.row = 3
        layout.dataSource = self
        let page = PageCollectionView(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 300), titles: titles, config: config, layout: layout)
        page.dataSource = self
        page.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionId)
        
        view.addSubview(page)
    }
}
extension CollectionViewTestVC : PageMultipageLayoutDataSource{
    func multipageLayoutColumn(at section: Int) -> Int {
        if section == 1 {
            return 4
        }else {
            return 7
        }
    }

    func multipageLayoutRow(at section: Int) -> Int {
        if section == 1 {
            return 2
        }else {
            return 3
        }
    }


}
extension CollectionViewTestVC : PageCollectionViewDataSource {
    func pageCollectionNumberOfSections(pageCollection: PageCollectionView, in collectionView: UICollectionView) -> Int {
        4
    }
    
    func pageCollection(pageCollection: PageCollectionView, _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Int(arc4random_uniform(30) + 30)
    }
    
    func pageCollection(pageCollection: PageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionId, for: indexPath)
        cell.contentView.backgroundColor = UIColor.randomColor()
        return cell
    }
    
    
}
