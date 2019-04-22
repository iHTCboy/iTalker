//
//  ITLanguageViewController.swift
//  iTalker
//
//  Created by HTC on 2017/4/8.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class ITLanguageViewController: ITBasePushTransitionVC {
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置 UI 界面
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        launchAnimate()
        self.tabBarController?.tabBar.tintColor = UIColor.orange
    }
    
    // MARK:- 懒加载
    fileprivate var titles = ["Object-C",
                              "Swift",
                              "Java",
                              "C&C++",
                              "PHP",
                              "JavaScript",
                              "Python",
                              "SQL",
                              "C#",
                              "HTML5",
                              "Ruby",
                              "R",
                              "Linux",
                              "BigData",
                              "Algorithm",
                              "NetworkSecurity"]
    
    fileprivate lazy var pageTitleView: ITPageTitleView = {
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavBarH, width: kScreenW, height: kTitleViewH)
        let titleView = ITPageTitleView(frame: titleFrame, titles: self.titles)
        titleView.delegate = self
        return titleView
    }()
    
    fileprivate lazy var pageContentView: ITPageContentView = {[weak self] in
        // 1. 确定内容 frame
        let contentH = kScreenH - kStatusBarH - kNavBarH - kHomeIndcator
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavBarH + kTitleViewH, width: kScreenW, height: contentH)
        // 2. 确定所有控制器
        let counts = 0
        var childVcs = [UIViewController]()
        if let counts = self?.titles.count {
            for i in 0..<counts {
                let vc = ITQuestionListViewController()
                vc.title = self?.titles[i]
                childVcs.append(vc)
            }
        }
        
    let contentView = ITPageContentView(frame: contentFrame, childVcs: childVcs, parentVc: self)
    contentView.delegate = self
    return contentView
    }()
    
    var isFirstLaunch = false
}


// MARK:- 设置 UI
extension ITLanguageViewController {
    fileprivate func setUpUI() {
        // 0. 不允许系统调整 scrollview 内边距
        automaticallyAdjustsScrollViewInsets = false
        
        // 1. 添加 titleview
        view.addSubview(pageTitleView)
        
        // 2. 添加 contentview
        view.addSubview(pageContentView)
    }
    
    func launchAnimate() {
        if !isFirstLaunch {
            isFirstLaunch = true
            
            let vc = UIStoryboard.init(name: "LaunchScreen", bundle: nil);
            let launchView = vc.instantiateInitialViewController()!.view
            let window =  UIWindow.init(frame: (view?.frame)!)
            window.windowLevel = UIWindow.Level.alert
            window.backgroundColor = UIColor.clear
            window.addSubview(launchView!)
            window.makeKeyAndVisible()
            
            UIView.animate(withDuration: 0.25, delay: 0.8, options: .beginFromCurrentState, animations: {
                launchView?.layer.transform = CATransform3DScale(CATransform3DIdentity, 2, 2, 1)
                launchView?.alpha = 0.0
            }, completion: { (true) in
                window.removeFromSuperview()
            })
        }
    }

}

// MARK:- pageTitleViewDelegate
extension ITLanguageViewController: ITPageTitleViewDelegate {
    func pageTitleView(pageTitleView: ITPageTitleView, didSelectedIndex index: Int) {
        pageContentView.scrollToIndex(index: index)
        selectTitleIndex = index
    }
}

// MARK:- pageContentViewDelegate
extension ITLanguageViewController: ITPageContentViewDelegate {
    func pageContentView(pageContentView: ITPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgerss(sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
        selectTitleIndex = targetIndex
    }
}




