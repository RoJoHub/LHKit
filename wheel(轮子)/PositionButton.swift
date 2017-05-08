//
//  PositionButton.swift
//  GlassesSale
//
//  Created by LuoHao on 16/12/19.
//  Copyright © 2016年 LuoHao. All rights reserved.
//

import UIKit

class PositionButton: UIButton {

    enum ImagePositionType {
        case bottom
        case left
        case right
        case top
    }
    var imagePosition:ImagePositionType = .top
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        self.titleLabel?.sizeToFit()
        
        let imgSize=(self.imageView?.intrinsicContentSize)!
        let titleSize=(self.titleLabel?.intrinsicContentSize)!
        
        let space:CGFloat=4
        
        switch imagePosition {
        case .top:
            let allHeight=imgSize.height+titleSize.height+space
            let allWidth=imgSize.width+titleSize.width
            
            let imageXOffset=(allWidth/2-imgSize.width/2)
            let imageYOffset=(allHeight-imgSize.height)/2
            
            self.imageEdgeInsets=UIEdgeInsetsMake(-imageYOffset, imageXOffset, imageYOffset,-imageXOffset)
            
            let titleXOffset=imgSize.width-(allWidth-titleSize.width)/2
            
            let titleYOffset=(allHeight-titleSize.height)/2
            
            self.titleEdgeInsets=UIEdgeInsetsMake(titleYOffset, -titleXOffset, -titleYOffset, titleXOffset)
        case .left:
            return
        case .right:
            let imageXOffset=titleSize.width
            let imageYOffset:CGFloat=0
            
            self.imageEdgeInsets=UIEdgeInsetsMake(-imageYOffset, imageXOffset, imageYOffset,-imageXOffset)
            
            let titleXOffset=imgSize.width
            
            let titleYOffset:CGFloat=0
            
            self.titleEdgeInsets=UIEdgeInsetsMake(titleYOffset, -titleXOffset, -titleYOffset, titleXOffset)
        default:
            return
        }
        
        
        
        
    }

}
