//
//  LHTabBarController.swift
//  Glassmania
//
//  Created by LuoHao on 2017/3/17.
//  Copyright © 2017年 LuoHao. All rights reserved.
//

import UIKit

class LHTabBarController: UITabBarController {
    
    
    //(tiele,imageName)
    var titleAndImageNameAndRatio:[(String,String,CGFloat)]!
    
    //默认为49
    var tabBarViewHeight:CGFloat=49
    
    
    
    private var _lhSelectedIndex: Int=0
    var lhSelectedIndex: Int {
        get {
            return _lhSelectedIndex
        }
        
        set {
            #if true
                if newValue==1 || newValue==2 {
                    guard loginUser != nil else {
                        
                        let vc=LoginController()
                        
                        
                        let nav=UINavigationController(rootViewController: vc)
                        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
                        nav.navigationBar.shadowImage = UIImage()
                        
                        self.present(nav, animated: true, completion: nil)
                        
                        
                        return
                    }
                }
            #endif
            _lhSelectedIndex=newValue
            self.selectedIndex=newValue
            self.tabBarView.selectedIndex(newValue)
            
        }
    }
    
    
    lazy var tabBarView: LHTabBarView = { [unowned self] in
        
        let view=LHTabBarView(lhframe: CGRect(x: 0, y: self.view.frame.size.height-self.tabBarViewHeight, width: self.view.frame.size.width, height: self.tabBarViewHeight))
        view.imageTitle=self.titleAndImageNameAndRatio
        return view
        }()
    var viewControllers_LH: [String] = [] {
        didSet{
            
            let vcs=viewControllers_LH.map { (className) -> UIViewController in
                let myClass=stringClassFrom(className: className) as! UIViewController.Type
                var obj=myClass.init()
                
                if !className.contains("One") {
                    obj=UINavigationController(rootViewController: obj)
                }
                return obj
                
            }
            self.view.addSubview(self.tabBarView)
            tabBarView.clickAction={[weak self] tag in
                self?.lhSelectedIndex=tag
                
                return self?.lhSelectedIndex == tag ? true :false
            }
            self.setViewControllers(vcs, animated: false)
        }
    }
    
    
    
}
extension LHTabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.selectedIndex=0
        self.tabBar.isHidden=true
        self.view.backgroundColor=UIColor.clear
        
        
    }
    
}
extension UIViewController{
    var lhTabbarController: LHTabBarController {
        
        return self.tabBarController as! LHTabBarController
    }
    
    
    
    var hidesTabBarWhenPushed: Bool {
        get {
            return self.boolProperty
        }
        set {
            self.boolProperty = newValue
            
            /**
             *  我们在这里使用class_addMethod()函数对Method Swizzling做了一层验证，如果self没有实现被交换的方法，会导致失败。
             *  而且self没有交换的方法实现，但是父类有这个方法，这样就会调用父类的方法，结果就不是我们想要的结果了。
             *  所以我们在这里通过class_addMethod()的验证，如果self实现了这个方法，class_addMethod()函数将会返回NO，我们就可以对其进行交换了。
             */
            if self.classForCoder.appendMethod(#selector(hideTabbarView_viewWillAppear(_:)), from: self.classForCoder) {
                //因为多次替换又变回原来的
                swizzleMethod()
            }
            
            
            
        }
    }
    
    private func swizzleMethod() {
        self.classForCoder.swizzleMethod(#selector(viewWillAppear(_:)),   withMethod: #selector(hideTabbarView_viewWillAppear(_:)))
        self.classForCoder.swizzleMethod(#selector(viewWillDisappear(_:)),   withMethod: #selector(hideTabbarView_viewWillDisappear(_:)))
    }
    @objc private func hideTabbarView_viewWillAppear(_ animated: Bool) {
        
        self.lhTabbarController.tabBarView.isHidden=true
        self.hideTabbarView_viewWillAppear(animated)
    }
    @objc private func hideTabbarView_viewWillDisappear(_ animated: Bool) {
        
        self.lhTabbarController.tabBarView.isHidden=false
        self.hideTabbarView_viewWillDisappear(animated)
    }
}

