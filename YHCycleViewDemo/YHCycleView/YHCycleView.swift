//
//  YHCycleView.swift
//  UIViewAnimatorDemo
//
//  Created by Mac on 2019/1/4.
//  Copyright © 2019 YangHao. All rights reserved.
//

import UIKit

enum YHCacheStrategy {
    
    /// 自动缓存
    case autoCaching
    
    /// 手动处理图片缓存
    case handCaching
    
}

public struct YHCycleViewConfiguration {
    
    /// 指示器
    var pageNormalColor:UIColor? = UIColor.gray
    var pageSelectorColor:UIColor? = UIColor.black
    
    /// 定时器
    var imageViewStayTimeInterval = 2
    var switchAnimationTimeInterval = 0.3
    
    /// 占位图
    var imagePlaceholder:UIImage?
    
    /// 缓存策略
    var caching:YHCacheStrategy? = .autoCaching
    
}

let imageViewCount = 3

@objc protocol YHCycleViewDelegate : NSObjectProtocol {
    
    /// 选中的图片
    ///
    /// - Parameter index: 图片下标
    func clickIndex(index:Int)
    
    /// 可选: 选择manuallyCaching时可执行此代理方法
    ///
    /// - Parameters:
    ///   - imageView: imageView视图
    ///   - index: 下标
    @objc optional func manuallyCachingImageView(imageView:UIImageView, index:Int)
    
}

class YHCycleView: UIView {
    
    private func cycleViewWidth() -> CGFloat {
        return bounds.size.width
    }
    
    private func cycleViewHeight() -> CGFloat {
        return bounds.size.height
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: bounds)
        scrollView.layer.cornerRadius = 5
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var pageCtrol: UIPageControl = {
        let pageCtrol = UIPageControl.init(frame: CGRect.init(x: 0, y: cycleViewHeight() - 20, width: bounds.size.width, height: 20))
        pageCtrol.isUserInteractionEnabled = false
        pageCtrol.hidesForSinglePage = true
        return pageCtrol
    }()
    
    private var tagPage = 0
    private var imagesCount = 0
    private var timer:Timer?
    
    public var cycleViewConfiguration:YHCycleViewConfiguration? {
        didSet {
            pageCtrol.currentPageIndicatorTintColor = cycleViewConfiguration?.pageSelectorColor
            pageCtrol.pageIndicatorTintColor = cycleViewConfiguration?.pageNormalColor
            for view in scrollView.subviews {
                let viewImg = view as? UIImageView
                viewImg?.image = cycleViewConfiguration?.imagePlaceholder
            }
        }
    }
    
    public var delegate:YHCycleViewDelegate?
    
    var images:[String]? {
        didSet {
            if images?.count == 0 {
                scrollView.isScrollEnabled = false
                return
            } else {
                imagesCount = images?.count ?? 0
                pageCtrol.numberOfPages = imagesCount
                startTimer()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubViews() {
        
        addSubview(scrollView)
        addSubview(pageCtrol)
        
        for i in 0..<imageViewCount {
            let iamgeView = YHImageView.init(frame: CGRect.init(x: cycleViewWidth() * CGFloat(i), y: 0, width: cycleViewWidth(), height: cycleViewHeight()))
            iamgeView.contentMode = .scaleAspectFill
            iamgeView.clipsToBounds = true
            iamgeView.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(clickImageView))
            iamgeView.addGestureRecognizer(tapGes)
            scrollView.addSubview(iamgeView)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        refreshFrame()
        
        if imagesCount == 0 {
            return
        }
        
        offsetImagesReset()
        startTimer()
        
    }
    
    private func refreshFrame() {
        
        scrollView.contentSize = CGSize.init(width: bounds.width * CGFloat(imageViewCount), height: 0)
        
        for (i,viewImg) in scrollView.subviews.enumerated() {
            viewImg.frame = CGRect.init(x: cycleViewWidth() * CGFloat(i), y: 0, width: cycleViewWidth(), height: cycleViewHeight())
        }
        
    }
    
    private func offsetImagesReset() {
        
        let offset = CGPoint.init(x: cycleViewWidth(), y: 0)
        scrollView.setContentOffset(offset, animated: false)
        
        guard let imagesTrue = images else {
            return
        }
        
        let sumCount = imagesTrue.count
        let indexFirst = (tagPage - 1 + imagesTrue.count) % sumCount
        let indexSecond = tagPage
        let indexLast = (tagPage + 1 + imagesTrue.count) % sumCount
        let indexList = [indexFirst,indexSecond,indexLast]
        
        for (i,view) in scrollView.subviews.enumerated() {
            guard let imageView:YHImageView = view as? YHImageView else {
                return
            }
            let index = indexList[i]
            
            guard let delegate = delegate else {
                return
            }
            
            if delegate.responds(to: #selector(YHCycleViewDelegate.manuallyCachingImageView(imageView:index:))),
                cycleViewConfiguration?.caching == .handCaching {
                delegate.manuallyCachingImageView?(imageView: imageView, index: index)
            }
            
            if cycleViewConfiguration?.caching == .autoCaching {
                imageView.asynSetImageData(imagePath: imagesTrue[index], placeholderImage: cycleViewConfiguration?.imagePlaceholder)
            }
            
        }
        
    }
    
    @objc func clickImageView() {
        guard let delegate = delegate else {
            return
        }
        if delegate.responds(to: #selector(YHCycleViewDelegate.clickIndex(index:))) {
            delegate.clickIndex(index: tagPage)
        }
    }
    
}

extension YHCycleView : UIScrollViewDelegate {
    
    /// 滚动时 -> 定位当前正确的页数
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset
        
        if offset.x <= 0 {
            
            /// 右滑
            pageDownCurrent()
            offsetImagesReset()
            
        } else if offset.x >= scrollView.frame.size.width * 2{
            
            /// 左滑
            pageUpCurrent()
            offsetImagesReset()
            
        }
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset
        let width = scrollView.frame.size.width
        
        if currentOffset.x > width && currentOffset.x < width * 2 {
            pageNext()
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        endTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    private func pageDownCurrent() {
        tagPage = (tagPage - 1 + imagesCount) % imagesCount
        pageCtrol.currentPage = tagPage
    }
    
    private func pageUpCurrent() {
        tagPage = (tagPage + 1) % imagesCount
        pageCtrol.currentPage = tagPage
    }
    
    private func pageNext() {
        let offset = CGPoint.init(x: scrollView.frame.size.width * 2, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
    
}


// MARK: - 定时器
extension YHCycleView {
    
    func startTimer() {
        
        if imagesCount == 0 {
            endTimer()
        }
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: Double((cycleViewConfiguration?.imageViewStayTimeInterval)!), target: self, selector: #selector(intermittentPerform), userInfo: nil, repeats: true)
            /// 线程不会被UI阻塞
            RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
        }
    }
    
    @objc func intermittentPerform() {
        /// 拖拽 || 移动
        if scrollView.isDragging || scrollView.isDecelerating {
            return
        } else {
            pageNext()
        }
    }
    
    private func endTimer() {
        if timer?.isValid == true {
            timer?.invalidate()
            timer = nil
        }
    }
    
}

class YHImageView : UIImageView {
    
    var recordImages = [String:UIImage]()
    
    func asynSetImageData(imagePath:String, placeholderImage:UIImage? = nil) {
        
        if imagePath.count == 0, placeholderImage != nil {
            
            image = placeholderImage
            
            return
        }
        
        if imagePath.contains("http") || imagePath.contains("file://") {
            
            var imageTake = recordImages[imagePath]
            
            if imageTake != nil {
                
                image = imageTake!
                
            } else {
                
                let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
                
                let imageNameNSString = imagePath as NSString
                
                let imageName = imageNameNSString.lastPathComponent as String
                
                let fullPath = "\(cachesPath!)" + "\(imageName)"
                
                let imageDataCaches = NSData.init(contentsOfFile: fullPath)
                
                if imageDataCaches != nil {
                    
                    let imageCaches = UIImage.init(data: imageDataCaches! as Data)
                    
                    image = imageCaches
                    
                    recordImages[imagePath] = imageCaches
                    
                } else {
                    print(imagePath)
                    DispatchQueue.global().async { [weak self] in
                        
                        /// 下载图片
                        var imageData : Data?
                        
                        imageData = try? Data(contentsOf: URL.init(string: imagePath)!, options: .mappedIfSafe)
                        
                        if imageData != nil {
                            
                            imageTake = UIImage.init(data: imageData!)
                            
                            self?.recordImages[imagePath] = imageTake
                            
                            let dataNS = imageData as NSData?
                            
                            dataNS?.write(toFile: fullPath, atomically: true)
                            
                            DispatchQueue.main.async {
                                self?.image = imageTake
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
            return
        }
        
        let imagePath = UIImage.init(named: imagePath)
        
        if imagePath != nil {
            
            image = imagePath
            
        } else {
            
            image = placeholderImage
            
        }
        
    }
    
}
