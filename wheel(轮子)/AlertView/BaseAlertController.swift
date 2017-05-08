//
//  BaseAlertController.swift
//  Glassmania
//
//  Created by LH-Mac on 2017/4/12.
//  Copyright © 2017年 LuoHao. All rights reserved.
//

import UIKit

class BaseAlertController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LHUtility.addNotification(self, selector: #selector(keyboardDidShow(aNotification:)), name: Notification.Name.UIKeyboardDidShow.rawValue)
        LHUtility.addNotification(self, selector: #selector(keyboardDidHide(aNotification:)), name: Notification.Name.UIKeyboardDidHide.rawValue)
        
    }
    deinit {
        LHUtility.removeNotification(self)
    }
    func keyboardDidShow(aNotification:Notification) {
        self.boolProperty=true
    }
    func keyboardDidHide(aNotification:Notification) {
        self.boolProperty=false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
        guard touches.first?.view == self.view else {
            return
        }
        guard self.boolProperty else {
            self.dismiss(animated: false, completion: nil)
            return
        }
        
        self.view.endEditing(true)
        
        
    }
    
}
extension UIViewController{
    func showLHAlert(vc:BaseAlertController) {
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
}
