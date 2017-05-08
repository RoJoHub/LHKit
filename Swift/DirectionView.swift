//
//  DirectionView.swift
//  GlassesKong
//
//  Created by LuoHao on 16/11/22.
//  Copyright © 2016 LuoHao. All rights reserved.
//

import UIKit

class DirectionView: UIView {
    
    var showClosure:((Bool)->())?
    
    lazy var pageControl: UIPageControl = {
        [unowned self] in
        let p=UIPageControl(frame: CGRect.zero)
        
        p.currentPageIndicatorTintColor=UIColor.white
        p.pageIndicatorTintColor=UIColor.gray
        p.numberOfPages=self.imgNames.count
        p.width=CGFloat(self.imgNames.count)*13
        p.height=37
        
        return p
        }()
    
    
    
    
    var currentItem:Int=0 {
        didSet{
            
            if showClosure != nil {
                let bool=(currentItem==3) ? true:false
                showClosure!(bool)
            }
        }
    }
    
    var imgNames: [String]!
    var imgCount: Int!
    var imgViews=[UIImageView]()
    
    lazy var scrollView:UIScrollView = {
        [unowned self] in
        let scView=UIScrollView(frame: self.bounds)
        
        scView.contentSize=CGSize(width: 3*ScreenWidth, height: 1)
        scView.bounces=false
        scView.isPagingEnabled=true
        scView.showsHorizontalScrollIndicator=false
        scView.showsVerticalScrollIndicator=false
        for i in 0..<3 {
            let rect=CGRect(x: CGFloat(i)*ScreenWidth, y: 0, width: ScreenWidth, height: ScreenHeight)
            let imageView=UIImageView(frame: rect)
            var offset=i
            if i==0{
                offset=self.imgNames.count-1
            }else if i==1{
                offset=0
            }else if i==2{
                offset=1
            }
            
            let img=UIImage.pngFromBundle(with: self.imgNames[offset])
            imageView.image=img
            
            imageView.contentMode = .scaleAspectFill
            self.imgViews.append(imageView)
            scView.contentOffset=CGPoint(x: ScreenWidth, y: 0)
            
            scView.addSubview(imageView)
            
        }
        
        
        
        return scView
        }()
    
    

    init(imageNames:[String]) {
        
        super.init(frame: CGRect())
        
        imgNames=imageNames
        imgCount=imgNames.count
        
        self.addSubview(scrollView)
        scrollView.delegate=self
        self.addSubview(pageControl)
        
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        LLog(message: "被销毁了")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame=self.bounds
        pageControl.center=CGPoint(x: self.centerX, y: self.height-90)
    }
    
}
extension DirectionView:UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        /*
         currentT
         初始为1
         只有0  1  2
         
         0表示减少
         1表示不动
         2表示增大
         */
        let currentT=Int(scrollView.contentOffset.x/ScreenWidth)
        
        if currentT==0 {
            if currentItem<=0 {
                currentItem=imgCount-1
            }else{
                currentItem-=1
            }
        }else if currentT==1{//不变
            return
        }else if currentT==2{//
            if currentItem>=imgCount-1 {
                currentItem=0
            }else{
                currentItem+=1
            }
        }
        //设置pageControl
        pageControl.currentPage=currentItem
        
        //设置左右的  图片名
        let leftString:String!
        let rightString:String!
        if currentItem==0{
            leftString=imgNames.last!
            rightString=imgNames[1]
        }else if currentItem==(imgCount-1){
            leftString=imgNames[imgCount-1-1]
            rightString=imgNames[0]
        }else{
            leftString=imgNames[currentItem-1]
            rightString=imgNames[currentItem+1]
        }
        
        //设置左边的 imgView
        let leftImgView=imgViews[0]
        leftImgView.image=UIImage.pngFromBundle(with: leftString)
        
        //设置中间的 imgView
        let midImgString=imgNames[currentItem]
        let img=UIImage.pngFromBundle(with: midImgString)
        let midImageView=imgViews[1]
        midImageView.image=img
        
        //设置右边的 imgView
        let rightImgView=imgViews[2]
        rightImgView.image=UIImage.pngFromBundle(with: rightString)
        
        
        
        scrollView.setContentOffset(CGPoint(x:ScreenWidth,y:0), animated: false)
    }
    
    
}

