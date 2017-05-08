//
//  PackageManager.swift
//  Glassmania
//
//  Created by LH-Mac on 2017/4/7.
//  Copyright © 2017年 LuoHao. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SwiftyJSON
func NetWorkError(){
    LHUtility.main_system {
        PackageManager.hide()
        PackageManager.showInfo(MBProgressHUD: "网络连接失败")
    }
    
}
extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
class PackageManager {
    static var hud:MBProgressHUD?
    class func netWorkTime(timeClosure:@escaping ((Date)->())){
        let url="http://cgi.im.qq.com/cgi-bin/cgi_svrtime"
        self.showMBProgressHUD(text: "")
        Alamofire.request(url).responseString { (res:DataResponse<String>) in
            self.hide()
            guard res.result.isSuccess else {
                NetWorkError()
                return
            }
            let value=res.result.value!
            LLog(message: res)
            
            
            let time=value.replacingOccurrences(of: "\n", with: "")
            
            let date=LHUtility.date(from: time)
            timeClosure(date)
            
        }
    }
}
//MARK:
//MARK:  网络连接
//MARK:
extension PackageManager{
    class func request_base(by url:String,method:HTTPMethod,parameters: Parameters? = nil,success:@escaping ((JSON)->()),failure:@escaping ((String)->())){
        LHUtility.main_system {
            PackageManager.showMBProgressHUD(text: "")
        }
        
        let manager=SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest=5
        
        Alamofire.request(url, method: method, parameters: parameters, headers: nil).responseJSON(queue: LHUtility.queue, options: .allowFragments) { (res) in
            LHUtility.main_system(closure: { 
                guard res.result.isSuccess else{
                    NetWorkError()
                    let error=res.error.debugDescription
                    
                    
                    failure(error)
                    
                    return
                }
                
                let jsonReslt=JSON.init(res.result.value!)
                
                LLog(message: jsonReslt.description)
                success(jsonReslt)
            })
            
        }
        
    }

    class func request(by url:String,method:HTTPMethod,parameters: Parameters? = nil,success:@escaping ((JSON)->()),failure:@escaping ((String)->())){

        
        
        PackageManager.request_base(by: url, method: method, parameters: parameters, success: { (json) in
            let dict=json.dictionaryValue
            
            guard let state = dict["Status"]?.intValue else {
                NetWorkError()
                return
            }
            
            guard state == 0 else{
                let error=(dict["Info"]?.stringValue)!
                LHUtility.main_system(closure: {
                    PackageManager.showInfo(MBProgressHUD: error)
                })
                
                failure(error)
                
                return
            }
            let result=dict["Data"]!
            LHUtility.main_system(closure: {
                PackageManager.hide()
            })
            
            success(result)
        }, failure: failure)
        
    }
    class func request_old(by url:String,method:HTTPMethod,parameters: Parameters? = nil,success:@escaping ((JSON)->()),failure:@escaping ((String)->())){
        
        
        PackageManager.request_base(by: url, method: method, parameters: parameters, success: { (json) in
            
            let dict=json.dictionaryValue
            
            guard let state = dict["state"]?.boolValue else {
                NetWorkError()
                return
            }
            guard state else{
                let error=(dict["message"]?.stringValue)!
                LHUtility.main_system(closure: {
                    PackageManager.showInfo(MBProgressHUD: error)
                })
                
                failure(error)
                
                return
            }
            let result=dict["jdata"]!
            LHUtility.main_system(closure: {
                PackageManager.hide()
            })
            
            success(result)
            
            
        }, failure: failure)
            
        
    }
    
    func checkVersionUpdate(appid:String) {
        
        
        let urlStr="https://itunes.apple.com/cn/lookup?id="+appid
        Alamofire.request(urlStr, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {( res:DataResponse<Any>) in
            
            guard res.result.isSuccess else{
                
                return
            }
            let json=JSON.init(res.result.value as Any)
            let dict=json["results"].array?.last?.dictionary
            let new_Version=dict?["version"]?.string
            
            guard new_Version != nil else {
                return
            }
            let old_Version=currentVersion()
            
            guard new_Version?.compare(old_Version) == .orderedDescending else {
                return
            }
            
            
            LHUtility.showAlert(title: "版本更新", message: "有新的版本可以更新,是否立即前往更新?", okBtnTitle: "立即更新", cancelBtnTitlte: "取消", OKBtnHandler: { (action) in
                let trunTo="itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id="+appid
                
                UIApplication.shared.openURL(URL(string: trunTo)!)
            }, cancelHandler: nil, completion: nil)
            
            
        })
        
        
    }
    
}
extension PackageManager{
    
    func requestWithHeader(by url:String,method:HTTPMethod,parameters: Parameters? = nil,success:@escaping ((JSON)->()),failure:@escaping ((String)->())){
        Alamofire.request(url, method: .put, parameters: nil, encoding: (loginUser?.id)!, headers: ["content-type" : "application/json"]).responseJSON { (res) in
            
        }
    }
}
//MARK:
//MARK:  MBProgressHUD
//MARK:

extension PackageManager{
    
    private class func createAndShowMBProgressHUD()->MBProgressHUD{
        if hud != nil {
            hide()
            hud=nil
        }
        //        let topVc=getAppTopController()
        
        return MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
    }
    class func showMBProgressHUD(text:String){
        hud=createAndShowMBProgressHUD()
        hud?.detailsLabel.text=text
    }
    class func hide(){
        guard hud != nil else {
            return
        }
        hud?.hide(animated: false)
        
        
    }
    class func hide(with text:String){
        hud?.detailsLabel.text=text
        hud?.hide(animated: true, afterDelay: 2)
        
        
    }
    class func showInfo(MBProgressHUD infoText:String){
        hud=createAndShowMBProgressHUD()
        hud?.mode = .text
        hud?.label.text=infoText
        hud?.offset=CGPoint(x: 0, y: MBProgressMaxOffset)
        hud?.hide(animated: true, afterDelay: 2)
        
        
    }
    
    class func showIndeterminateMBProgressHUD(title:String,description:String){
        hud=createAndShowMBProgressHUD()
        
        hud?.label.text = title;
        // Will look best, if we set a minimum size.
        hud?.minSize = CGSize(width: 150, height: 150)
        sleep(UInt32(0.5))
        hud?.mode = .determinate;
        hud?.label.text = description;
    }
    class func updateIndeterminate(With progress:Float){
        
        DispatchQueue.main.async {
            hud?.progress=progress
        }
    }
    class func hideIndeterminateMBProgressHUD(hideString:String){
        let image=UIImage.init(named: "Checkmark")?.withRenderingMode(.alwaysTemplate)
        
        let imageView=UIImageView(image: image)
        
        hud?.customView=imageView
        hud?.mode = .customView
        hud?.label.text=hideString
        hud?.hide(animated: true, afterDelay: 2)
        
    }
}

