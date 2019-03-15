//
//  ViewController.swift
//  YHCycleViewDemo
//
//  Created by Mac on 2018/10/4.
//  Copyright © 2018 YangHao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var autoButton: UIButton = {
        let autoButton = UIButton.init(frame: CGRect.init(x: 0, y: 300, width: view.bounds.size.width, height: 30))
        autoButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        autoButton.setTitle("使用此框架下载图片自动缓存", for: .normal)
        autoButton.setTitleColor(UIColor.red, for: .normal)
        autoButton.addTarget(self, action: #selector(autoPush), for: .touchUpInside)
        return autoButton
    }()

    lazy var handButton: UIButton = {
        let handButton = UIButton.init(frame: CGRect.init(x: 0, y: 370, width: view.bounds.size.width, height: 30))
        handButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        handButton.setTitle("使用三方Kingfisher,SDwebImage,或手动缓存", for: .normal)
        handButton.setTitleColor(UIColor.red, for: .normal)
        handButton.addTarget(self, action: #selector(handPush), for: .touchUpInside)
        return handButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Swift无限轮播高性能"

        view.addSubview(autoButton)
        view.addSubview(handButton)

    }

    @objc func autoPush() {
        navigationController?.pushViewController(AutoViewController.init(), animated: true)
    }

    @objc func handPush() {
        navigationController?.pushViewController(HandViewController.init(), animated: true)
    }

}
