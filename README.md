# LCCPageView

[![CI Status](https://img.shields.io/travis/lu63chuan@163.com/LCCPageView.svg?style=flat)](https://travis-ci.org/lu63chuan@163.com/LCCPageView)
[![Version](https://img.shields.io/cocoapods/v/LCCPageView.svg?style=flat)](https://cocoapods.org/pods/LCCPageView)
[![License](https://img.shields.io/cocoapods/l/LCCPageView.svg?style=flat)](https://cocoapods.org/pods/LCCPageView)
[![Platform](https://img.shields.io/cocoapods/p/LCCPageView.svg?style=flat)](https://cocoapods.org/pods/LCCPageView)

## Example
### 横向表情键盘
![](https://github.com/L63C/LCCPageView/blob/aa9874781106d656b6c3466fd49c8778396af7c9/appVideo.mov)
```
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
```
### 类似今日头条的滑动标题
![](https://github.com/L63C/LCCPageView/blob/3a2c733343432c6656b9d94a136d8ffd690a10fb/title.mov)
```
//import LCCPageView
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

```

## Requirements

## Installation

LCCPageView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LCCPageView'
```

## Author

lu63chuan@163.com, lu63chuan@163.com

## License

LCCPageView is available under the MIT license. See the LICENSE file for more info.
