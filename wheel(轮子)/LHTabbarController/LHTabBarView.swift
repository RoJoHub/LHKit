//
//  LHTabBarView.swift
//  Glassmania
//
//  Created by LuoHao on 2017/3/17.
//  Copyright © 2017年 LuoHao. All rights reserved.
//

import UIKit

class LHTabBarView: UIView {
    var clickAction:((Int)->Bool)?
    
    var currentSeleletedView: (UIButton,UILabel)! {
        willSet{
            if currentSeleletedView != nil {
                currentSeleletedView.0.isSelected=false
                currentSeleletedView.1.textColor=UIColor.black
            }
            newValue.0.isSelected=true
            
            newValue.1.textColor=AppColor
        }
    }
    lazy var hengXianView: UIView = {[unowned self] in
        let v=UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0.5))
        v.backgroundColor=UIColor.darkGray
            
            
        return v
    }()
    var labels = [UILabel]()
    var btns = [UIButton]()
    var imageTitle: [(String,String,CGFloat)] = []{
        
        didSet{
            let btnW=self.frame.width/CGFloat(imageTitle.count)
            
            for index in 0..<imageTitle.count {
                let i=CGFloat(index)
                let btn=self.btn
                btns.append(btn)
                btn.frame=CGRect(x: btnW*i, y: 0, width: btnW, height: self.frame.size.height)
                btn.tag=index
                
                let image=UIImage.scaleWith(imageName: imageTitle[index].1, ratio: imageTitle[index].2, width: nil, height: 49-32)
                btn.setImage(image, for: .normal)
                let s_image=UIImage.scaleWith(imageName: imageTitle[index].1+"_s", ratio: imageTitle[index].2, width: nil, height: 49-32)
                btn.setImage(s_image, for: .selected)
                self.addSubview(btn)
                
                
                let label=self.titleLabel
                label.text=imageTitle[index].0
                label.frame=CGRect(x: i*btnW, y: 30, width: btnW, height: 15)
                self.addSubview(label)
                if index==0 {
                    self.currentSeleletedView=(btn,label)
                }
                
                
                labels.append(label)
            }
        }
    }
    
    
    convenience init(lhframe:CGRect) {
        
        
        self.init()
        self.frame=lhframe
        
        self.alpha=0.8
        self.backgroundColor=UIColor.white
        self.addSubview(hengXianView)
    }
    
    
    
    
    
}
extension LHTabBarView{
    var btn: UIButton {
        let btn=UIButton(type: .custom)
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        btn.contentEdgeInsets=UIEdgeInsetsMake(-15, 0, 0, 0);
        return btn
    }
    var titleLabel:UILabel{
        let label=UILabel()
        label.textColor=UIColor.black
        label.font=UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        
        return label
    }
    func btnClick(btn:UIButton)  {
        if clickAction != nil {
            let bool=clickAction!(btn.tag)
            if bool {
                selectedIndex(btn.tag)
            }
            
            
        }
    }
    func selectedIndex(_ index:Int)  {
        
        currentSeleletedView=(btns[index],labels[index])

    }
}

