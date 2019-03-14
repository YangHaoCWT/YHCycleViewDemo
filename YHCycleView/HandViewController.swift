//
//  HandViewController.swift
//  YHCycleViewDemo
//
//  Created by Mac on 2018/10/4.
//  Copyright © 2018 YangHao. All rights reserved.
//

import UIKit
//import Kingfisher

class HandViewController: UIViewController, YHCycleViewDelegate {

    lazy var images: [String] = {
        let images = [
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546850420105&di=c459921b4391eff012b641b2cd68d56e&imgtype=0&src=http%3A%2F%2Fp9.qhimg.com%2Ft0174eafed8b2ae90f3.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546850388285&di=0644ccedd0ad168a3be1119bc174ca68&imgtype=0&src=http%3A%2F%2Fwx1.sinaimg.cn%2Flarge%2F6fe0484egy1fvgywhipdvj20rs0fmnde.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546850364329&di=528a7159575e54d68e4d9e290a2d0bc4&imgtype=0&src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201812%2F10%2F231855basa2bkay3yv3jsg.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546850457369&di=2d442512232de33c35456ce260e58c9b&imgtype=0&src=http%3A%2F%2Fbpic.wotucdn.com%2F18%2F95%2F59%2F18955969-490debe6897b879f771ef9499764792c-1.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546850479326&di=e817366ecbd9faad63f38ea941fd5db3&imgtype=0&src=http%3A%2F%2Fpic1.zhimg.com%2Fv2-ef8afa7e8659d17018ba2a9ea57e3c8c_b.jpg"
        ]
        return images
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        handCaching()
    }

    func handCaching() {

        /// 配置
        var configuration = YHCycleViewConfiguration.init()
        configuration.imagePlaceholder = UIImage.init(named: "pla")
        configuration.caching = .handCaching

        let carouselView = YHCycleView.init(frame: CGRect.init(x: 0, y: 200, width: view.bounds.width, height: 200))
        carouselView.delegate = self
        carouselView.cycleViewConfiguration = configuration
        carouselView.images = images
        view.addSubview(carouselView)

    }

    // MARK: - 点击的下标
    func clickIndex(index: Int) {
        print("点击了第\(index + 1)张图片")
    }

    func manuallyCachingImageView(imageView: UIImageView, index: Int) {
        /// Kingfisher || SDwebImage || 手动缓存
//        imageView.kf.setImage(with: URL.init(string: images[index]), placeholder: UIImage.init(named: "pla"), options: nil, progressBlock: nil, completionHandler: { (image, error, type, url) in
//        })
    }

}
