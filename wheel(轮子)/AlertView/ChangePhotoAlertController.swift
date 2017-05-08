//
//  ChangeAvatorAlertView.swift
//  Glassmania
//
//  Created by LH-Mac on 2017/4/1.
//  Copyright © 2017年 LuoHao. All rights reserved.
//

import UIKit

class ChangePhotoAlertController: BaseAlertController {


    weak var delegate:(UIImagePickerControllerDelegate & UINavigationControllerDelegate)!
    weak var imgPickController:UIImagePickerController!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    @IBOutlet weak var containView: UIView!
    
    
    @IBOutlet weak var takePhotoBtn: UIButton!
    
    
    
    @IBOutlet weak var albumBtn: UIButton!
    
    enum ActionType :Int{
        case takePhoto = 1
        case chooseFromAlbum
        case cancel
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containView.corner(15)
        albumBtn.layer.borderColor=UIColor.rbg(169, 169, 169).cgColor
        albumBtn.layer.borderWidth=1
        let image1=UIImage.scaleWith(imageName: "photo_camera", ratio: 39/38, width: nil, height: 16)
        takePhotoBtn.setImage(image1, for: .normal)
        
        let image2=UIImage.scaleWith(imageName: "photo_albow", ratio: 40/38, width: nil, height: 16)
        albumBtn.setImage(image2, for: .normal)
        
        //摄像头改变的通知
        LHUtility.addNotification(self, selector: #selector(cameraChanged), name: "AVCaptureDeviceDidStartRunningNotification")
    }
    
    
    
    @IBAction func clickAction(_ sender: UIButton) {
        let type=ActionType(rawValue: sender.tag)!
        
        
        
        switch type {
        case .takePhoto :
            choosePhoto(by: .camera)
        case .chooseFromAlbum:
            choosePhoto(by: .savedPhotosAlbum)
        case .cancel:
            self.dismiss(animated: false, completion: nil)
        }
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let space=(self.containView.width-85-17)/2
        self.takePhotoBtn.contentEdgeInsets=UIEdgeInsets(top: 0, left: space, bottom: 0, right: 0)
        
        self.albumBtn.contentEdgeInsets=UIEdgeInsets(top: 0, left: space, bottom: 0, right: 0)
    }
    
    private func choosePhoto(by type:UIImagePickerControllerSourceType)  {
        let imgVC=UIImagePickerController()
        imgPickController=imgVC
        imgVC.sourceType=type
        imgVC.delegate=self.delegate
        
        imgVC.allowsEditing=false
        imgVC.modalPresentationStyle = .currentContext;
        imgVC.modalPresentationStyle = (type == .camera) ? .fullScreen:.popover
        let p=self.presentingViewController!
        self.dismiss(animated: false) {
            p.present(imgVC, animated: true, completion: nil)
        }
        
        
    }
    func cameraChanged() {
        guard imgPickController != nil else {
            return
        }
        imgPickController.cameraViewTransform = CGAffineTransform.identity;
        if imgPickController.cameraDevice == .front {
            
            imgPickController.cameraViewTransform = CGAffineTransform(scaleX:-1,y:1)
        }
    }
    
    
    
    deinit {
        LHUtility.removeNotification(self)
    }
}
