//
//  TopSliderItemView.swift
//  Glassmania
//
//  Created by LH-Mac on 2017/4/5.
//  Copyright © 2017年 LuoHao. All rights reserved.
//

import UIKit

class TopSliderItemView: UIView {
    var registerCollecitonCellClosure:((UICollectionView)->())!
    var titles:[String]!
    var itemChangeClosure:((Int,UICollectionView)->())?
    
    var currentPage:Int=1
    var btnWidth:CGFloat=0
    var btnHeight:CGFloat=49
    var showTitleCount:CGFloat=3
    var lineWidth:CGFloat!
    
    var currentButton:UIButton!
    
    
    weak var dataSource:UICollectionViewDataSource? {
        didSet{
            collectionView.dataSource=dataSource
        }
    }
    
    lazy var topButtons: [UIButton] = {[unowned self] in
        var array=[UIButton]()
        for i in 0..<self.titles.count{
            let button=UIButton(type: .custom)
            if i==0{
                self.currentButton=button
                self.currentButton.isSelected=true
            }
            button.tag=i+1
            
            button.frame=CGRect(x: CGFloat(i)*self.btnWidth, y: 0, width: self.btnWidth, height: self.btnHeight)
            button.setTitle(self.titles[i], for: .normal)
            button.titleLabel?.font=UIFont.systemFont(ofSize: 15)
            
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(AppColor, for: .selected)
            button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            array.append(button)
        }
        return array
    }()
    
    lazy var topSliderBar: UIScrollView = {[unowned self] in
        
        let v=UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.btnHeight))
        v.contentSize=CGSize(width: CGFloat(self.titles.count)*self.btnWidth, height: 1)
        v.showsVerticalScrollIndicator=false
        v.bounces=false
        v.backgroundColor=UIColor.clear
        v.clipsToBounds=false
        return v
    }()
    lazy var sliderLine: CALayer = {[unowned self] in
        self.lineWidth=self.btnWidth/2
        let lineX=(self.btnWidth-self.lineWidth)/2
        let lineY=self.btnHeight-5
        
        let layer=CALayer()
        layer.frame=CGRect(x: lineX, y: lineY, width: self.lineWidth, height: 5)
        layer.backgroundColor=AppColor.cgColor
        return layer
    }()
    lazy var underLine: CALayer = {[unowned self] in
        let space:CGFloat=10
        let layer=CALayer()
        layer.frame=CGRect(x: space, y: self.btnHeight-3, width: self.frame.size.width-2*space, height: 1)
        layer.backgroundColor=AppColor.cgColor
        return layer
    }()
    lazy var layout: UICollectionViewFlowLayout = {[unowned self] in
        let layout=UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let space:CGFloat=10
        let itemSize=CGSize(width: self.frame.size.width-2*space, height: self.frame.size.height-self.btnHeight-space)
        layout.itemSize=itemSize
        layout.minimumLineSpacing=0
        layout.minimumInteritemSpacing=0
        layout.sectionInset=UIEdgeInsets.zero
        return layout
    }()
    lazy var collectionView: UICollectionView = {[unowned self] in
        
        let collectionView=UICollectionView(frame: CGRect(x:10, y: self.btnHeight, width:  self.layout.itemSize.width, height: self.layout.itemSize.height), collectionViewLayout: self.layout)
        
        collectionView.isPagingEnabled=true
        collectionView.showsHorizontalScrollIndicator=false
        collectionView.backgroundColor=UIColor.white
        collectionView.dataSource=self.dataSource
        collectionView.delegate=self
        self.registerCollecitonCellClosure(collectionView)
        return collectionView
    }()
    
    
}
extension TopSliderItemView{
    convenience init(
        titles:[String],
        frame:CGRect,
        btnHeight:CGFloat=49,
        showTitleCount:CGFloat=3,
        weakDataSource:UICollectionViewDataSource?,
        registerCollecitonCellClosure:@escaping ((UICollectionView)->()),
        itemChangeClosure:((Int,UICollectionView)->())? = nil) {
        self.init(frame: frame)
        
        
        self.btnWidth=self.frame.size.width/3
        self.itemChangeClosure=itemChangeClosure
        self.registerCollecitonCellClosure=registerCollecitonCellClosure
        self.titles=titles
        self.btnHeight=btnHeight
        
        
        self.showTitleCount=showTitleCount
        self.backgroundColor=UIColor.clear
        
        
        self.addSubview(topSliderBar)
        topSliderBar.layer.addSublayer(sliderLine)
        topSliderBar.layer.addSublayer(underLine)
        _=topButtons.map {[unowned self] btn->Void in
            self.topSliderBar.addSubview(btn)
        }
        
        
        
        self.dataSource=weakDataSource
        self.addSubview(collectionView)
        
        
    }
    func btnClick(btn:UIButton) {
        currentButton.isSelected=false
        btn.isSelected=true
        currentButton=btn
        let indexPath=IndexPath(row: btn.tag-1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        currentPage=btn.tag-1
        pageChange()
    }
    func pageChange() {
        if itemChangeClosure != nil {
            itemChangeClosure!(currentPage+1,collectionView)
        }
        
    }
}
extension TopSliderItemView:UIScrollViewDelegate,UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        currentPage=Int((collectionView.contentOffset.x+0.5*self.frame.size.width)/self.frame.size.width)
        UIView.animate(withDuration: 0.2) {[unowned self] in
            
            let xValue=(self.btnWidth-self.lineWidth)/2+self.btnWidth*CGFloat(self.currentPage)
            
            self.sliderLine.frame=CGRect(x: xValue, y: self.sliderLine.frame.origin.y, width: self.sliderLine.frame.size.width, height: self.sliderLine.frame.size.height)
            
            if self.currentPage>=3&&self.currentPage<=Int(self.titles.count-2){
                
                self.topSliderBar.contentOffset=CGPoint(x: self.frame.size.width/5*(CGFloat(self.currentPage)-2), y: self.topSliderBar.contentOffset.y)
            }else if self.currentPage==0{
                self.topSliderBar.contentOffset=CGPoint(x: 0, y: self.topSliderBar.contentOffset.y)
            }
            
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        currentButton.isSelected=false
        let btn=topButtons[currentPage]
        btn.isSelected=true
        currentButton=btn
        UIView.animate(withDuration: 0.2) {[unowned self] in
            let xValue=(self.btnWidth-self.lineWidth)/2+self.btnWidth*CGFloat(self.currentPage)
            self.sliderLine.frame=CGRect(x: xValue, y: self.sliderLine.frame.origin.y, width: self.sliderLine.frame.size.width, height: self.sliderLine.frame.size.height)
        }
        
        
        pageChange()
    }
    
}
