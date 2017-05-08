//
//  ChangeSexAlertView.swift
//  Glassmania
//
//  Created by LH-Mac on 2017/4/5.
//  Copyright © 2017年 LuoHao. All rights reserved.
//

import UIKit

class ChangeSexAlertController: BaseAlertController {

    var changeSexClosure:((String)->())!
    
    @IBOutlet weak var containView: UIView!
    
    
    @IBOutlet weak var manBtn: UIButton!
    
    
    
    @IBOutlet weak var womanBtn: UIButton!
    
    
    @IBOutlet weak var secrectBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containView.corner(15)
        manBtn.layer.borderColor=UIColor.rbg(169, 169, 169).cgColor
        manBtn.layer.borderWidth=1
        let image1=UIImage.scaleWith(imageName: "man_img", ratio: 55/56, width: nil, height: 16)
        manBtn.setImage(image1, for: .normal)
        
        let image2=UIImage.scaleWith(imageName: "woman_img", ratio: 43/60, width: nil, height: 16)
        womanBtn.setImage(image2, for: .normal)
        
        womanBtn.layer.borderColor=UIColor.rbg(169, 169, 169).cgColor
        womanBtn.layer.borderWidth=1
    }
    enum ActionType :Int{
        case man = 1
        case woman
        case secrect
    }
    @IBAction func clickAction(_ sender: UIButton) {
        let type=ActionType(rawValue: sender.tag)!
        switch type {
        case .man :
            changeSexClosure("男性")
            
        case .woman:
            changeSexClosure("女性")
        case .secrect:
            changeSexClosure("保密")
            
        }
        
        self.dismiss(animated: false, completion: nil)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let space=(self.containView.width-40-17)/2
        manBtn.contentEdgeInsets=UIEdgeInsets(top: 0, left: space, bottom: 0, right: 0)
        
        womanBtn.contentEdgeInsets=UIEdgeInsets(top: 0, left: space, bottom: 0, right: 0)
    }
}
