//
//  ChangePwdAlertView.swift
//  Glassmania
//
//  Created by LH-Mac on 2017/4/5.
//  Copyright © 2017年 LuoHao. All rights reserved.
//

import UIKit

class ChangePwdAlertController: BaseAlertController {
    var finishClosure:((_ oldPwd:String,_ newPwd:String)->())!
    @IBOutlet weak var containLineView: UIView!
   
    
    @IBOutlet weak var okBtn: UIButton!

    @IBOutlet weak var containView: UIView!
    
    
    @IBOutlet weak var oldPwdTextField: UITextField!
    
    @IBOutlet weak var newPwdTextField: UITextField!
    
    @IBOutlet weak var reNewPwdTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        containView.corner(15)
        containLineView.layer.borderWidth=1
        containLineView.layer.borderColor=UIColor.rbg(169, 169, 169).cgColor
        oldPwdTextField.delegate=self
        newPwdTextField.delegate=self
        reNewPwdTextField.delegate=self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        okBtn.corner(okBtn.height/2)
    }
    enum ActionType :Int{
        case man = 1
        case woman
        case secrect
    }
    @IBAction func clickAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        guard (oldPwdTextField.text?.characters.count)!>0 else {
            
            return
        }
        guard (newPwdTextField.text?.characters.count)!>0 else {
            return
        }
        guard (reNewPwdTextField.text?.characters.count)!>0 else {
            return
        }
        guard reNewPwdTextField.text == newPwdTextField.text else {
            PackageManager.showInfo(MBProgressHUD: "两次输入的密码不一致")
            return
        }
        self.finishClosure(oldPwdTextField.text!,reNewPwdTextField.text!)
        self.dismiss(animated: false, completion: nil)
    }
    
}
extension ChangePwdAlertController:UITextFieldDelegate{
    
    
    
    
    //MARK:  UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
