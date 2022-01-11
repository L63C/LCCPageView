//
//  PageTitleView.swift
//  LCPageView
//
//  Created by L63 on 2021/12/7.
//

import UIKit
public protocol PageTitleViewDelegate: AnyObject {
    func pageTitleView(_ titleView: PageTitleView,didSelect index: Int)
}

public class PageTitleView: UIView {
    fileprivate let titles: [String]
    fileprivate let config: PageTitleConfig
    fileprivate var labs: [UILabel] = [UILabel]()
    fileprivate var currentIdx: Int = 0
    weak var delegate: PageTitleViewDelegate?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    lazy var lineView: UIView = {
        let lineView = UIView(frame: .zero)
        lineView.backgroundColor = config.lineColor
        return lineView
    }()
    public init(frame: CGRect,
                titles:[String],
                config:PageTitleConfig) {
        self.titles = titles
        self.config = config
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension PageTitleView {
    fileprivate func setupUI() {
        scrollView.frame = self.bounds
        addSubview(scrollView)
        setupLabs()
        setupLabFrame()
        setupLine()
    }
    fileprivate func setupLabs() {
        backgroundColor = config.bgColor
        for (idx,title) in titles.enumerated() {
            let label = UILabel(frame: .zero)
            label.textColor = config.normalColor
            label.font = config.normalFont
            label.text = title
            label.tag = idx
            label.textAlignment = .center
            scrollView.addSubview(label)
            labs.append(label)
            if idx == 0 {
                label.font = config.selectFont
                label.textColor = config.selectColor
            }
            label.isUserInteractionEnabled = true
            let tagGes = UITapGestureRecognizer(target: self, action: #selector(labTapAction(_:)))
            label.addGestureRecognizer(tagGes)
        }
    }
    fileprivate func setupLabFrame() {
        let count = titles.count
        for (idx, lab) in labs.enumerated() {
            var w:CGFloat = 0
            let h:CGFloat = self.bounds.size.height
            var x:CGFloat = 0
            let y:CGFloat = 0
            if config.scrollable {
                let font = idx == 0 ? config.selectFont : config.normalFont
                
                w = (titles[idx] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [.font:font], context: nil).width
                if idx == 0 {
                    x = config.margin * 0.5
                }else {
                    x = labs[idx - 1].frame.maxX + config.margin
                }
            }else {
                w = self.bounds.size.width / CGFloat(count)
                x = CGFloat(idx) * w
            }
            lab.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        scrollView.contentSize = CGSize(width: labs.last!.frame.maxX + config.margin * 0.5, height: 0)
    }
    fileprivate func setupLine() {
        guard config.needShowLine else {
            return
        }
        lineView.frame.origin.y = config.titleH - config.lineH
        lineView.frame.size.height = config.lineH
        if config.scrollable {
            lineView.frame.origin.x = config.margin * 0.5
            lineView.frame.size.width = labs[currentIdx].frame.width
        }else {
            lineView.frame.origin.x = 0
            lineView.frame.size.width = self.bounds.width / CGFloat(titles.count)
        }
        scrollView.addSubview(lineView)
        
    }
    
}
/// MARK: - Action
extension PageTitleView {
    @objc fileprivate func labTapAction(_ gesture:UIGestureRecognizer) {
        guard let lab = gesture.view as? UILabel else {
            return
        }
        selectOneTitle(idx: lab.tag)
        delegate?.pageTitleView(self, didSelect: lab.tag)
    }
}
///MAR: - public methods
extension PageTitleView{
    public func selectOneTitle(idx:Int) {
        let lab = labs[idx]
        let preLab = labs[currentIdx]
        preLab.font = config.normalFont
        preLab.textColor = config.normalColor
        currentIdx = lab.tag
        lab.font = config.selectFont
        lab.textColor = config.selectColor
        
        if config.scrollable {
            // 居中
            var offsetX = lab.center.x - scrollView.frame.width * 0.5
            if offsetX < 0 {
                offsetX = 0
            }else if offsetX + scrollView.frame.width > scrollView.contentSize.width {
                offsetX = scrollView.contentSize.width - scrollView.frame.width
            }
            scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
           
        }
        if config.needShowLine {
            if config.lineAnimate {
                UIView.animate(withDuration: 0.25) {
                    self.lineView.frame.origin.x = lab.frame.origin.x
                    self.lineView.frame.size.width = lab.frame.width
                }
            }else {
                self.lineView.frame.origin.x = lab.frame.origin.x
                self.lineView.frame.size.width = lab.frame.width
            }
           
        }
        
    }
   public func selectTitle(sourceIdx: Int, targetIdx: Int, progress: CGFloat) {
        let sourceLab = labs[sourceIdx]
        let targetLab = labs[targetIdx]
        // 颜色
        if config.needGradient {
            sourceLab.textColor = progressColor(source: config.selectColor, target: config.normalColor, progress: progress)
            targetLab.textColor = progressColor(source: config.normalColor, target: config.selectColor, progress: progress)
        }
        //字体
        sourceLab.font = UIFont.systemFont(ofSize: progressValue(source: config.selectFont.pointSize, target: config.normalFont.pointSize, progress: progress))
        targetLab.font = UIFont.systemFont(ofSize: progressValue(source: config.normalFont.pointSize, target: config.selectFont.pointSize, progress: progress))
        // 线条
        if config.lineAnimate && config.needShowLine{
            lineView.frame.origin.x = progressValue(source: sourceLab.frame.origin.x, target: targetLab.frame.origin.x, progress: progress)
            lineView.frame.size.width = progressValue(source: sourceLab.frame.size.width, target: targetLab.frame.size.width, progress: progress)
        }
        
    }
}
extension PageTitleView {
    fileprivate func progressColor(source:UIColor,target:UIColor,progress:CGFloat) -> UIColor {
        guard let sourceColors = source.cgColor.components,let targetColors = target.cgColor.components  else {
            fatalError("please user 'init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)' create color ")
        }
        
        let r = progressValue(source: sourceColors[0], target: targetColors[0], progress: progress)
        let g = progressValue(source: sourceColors[1], target: targetColors[1], progress: progress)
        let b = progressValue(source: sourceColors[2], target: targetColors[2], progress: progress)
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    fileprivate func progressValue(source:CGFloat,target:CGFloat,progress:CGFloat) -> CGFloat {
        guard source != target else {
            return source
        }
        return (target - source) * progress + source
    }
}
