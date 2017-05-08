//
//  LHUtility.swift
//  GlassesKong
//
//  Created by LuoHao on 16/10/31.
//  Copyright © 2016 LuoHao. All rights reserved.
//

import UIKit


typealias Closures_AlertHandle = (((UIAlertAction) -> Void)?)
typealias Closures_AlertCompletion = (((UIAlertAction) -> Void)?)
class LHUtility: NSObject {
    
    static let queue : DispatchQueue=DispatchQueue(label: "LHQueue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    static let mainQueue : DispatchQueue=DispatchQueue.main
    
    
    class func async(closure:(()->())?){
        guard (closure != nil) else {
            return
        }
        queue.async {
            closure!()
        }
    }
    class func main_async(closure:(()->())?){
        guard (closure != nil) else {
            return
        }
        queue.async {
            DispatchQueue.main.async {
                closure!()
            }
        }
    }
    class func main_system(closure:(()->())?){
        guard (closure != nil) else {
            return
        }
        DispatchQueue.main.async {
            closure!()
        }
    }
    
    
    
    class func call(phoneNumber:String){
        let string="tel:"+phoneNumber
        let url=URL(string: string)
        UIApplication.shared.openURL(url!)
    }
    
    class func warmFreeDisk(_ mbNumer:Int64){
        if isFreeDiskIsMoreThan(mbNumer) {
            showAlert(title: "剩余空间警告" , message: "检测到您的手机空间不足300MB,请及时清理手机存储空间,以便正常使用眼镜控", okBtnTitle: "知道了", cancelBtnTitlte: nil, OKBtnHandler: nil, cancelHandler: nil, completion: nil)
        }
    }
    class func isFreeDiskIsMoreThan(_ mbNumer:Int64)->Bool{
        var buf:statfs? = nil
        
        
        var freespace:CLongLong = -1
        
        if statfs("/var", &buf!) >= 0{
            freespace = CLongLong( (buf?.f_bsize)!) * CLongLong((buf?.f_bfree)!);
        }
        
        let mb=freespace/1024/1024
        
        return mb > mbNumer
        
    }
    
    
    //MARK:
    //MARK:  确定和取消的提示框
    //MARK:
    
    
    class func showAlert(title:String?,message:String?,okBtnTitle:String?,cancelBtnTitlte:String?,OKBtnHandler:Closures_AlertHandle?,cancelHandler:Closures_AlertHandle?,completion:Closures_AlertCompletion?) -> Void{
        
        let alertController=UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        
        alertController.addAction(UIAlertAction(title: okBtnTitle, style: .default, handler: OKBtnHandler!))
        
        if cancelBtnTitlte != nil {
            var calHand=cancelHandler
            if calHand == nil {
                calHand={ action in
                    
                }
            }
            alertController.addAction(UIAlertAction(title: cancelBtnTitlte, style: .default, handler: calHand!))
        }
        
        self.getAppTopController().present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK:
    //MARK:  1.获得当前应用顶级控制器
    //MARK:  2.获得View上的控制器
    //MARK:
    
    class func getAppTopController()->UIViewController{
        
        var topController :UIViewController? = UIApplication.shared.keyWindow!.rootViewController
        
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController;
        }
        
        return topController!;
    }
    
    
    
    class func attachViewController(view:UIView)->UIViewController?{
        
        let controller:UIViewController?
        
        var superView:UIView?=view.superview
        var nextResponder:UIResponder?
        
        while superView != nil {
            
            nextResponder=nextResponder?.next
            
            if (nextResponder?.isKind(of: UIViewController.self))! {
                controller=nextResponder as! UIViewController!
                return controller
            }
            
            superView=superView?.superview
        }
        return nil
        
    }
    
    
    
    
    //MARK:
    //MARK:  子控制器
    //MARK:
    
    class func allocContrller(name:String,moveTo parentController:UIViewController) ->UIViewController{
    
        let myClass=stringClassFrom(className: name) as! UIViewController.Type
        
        let childController : UIViewController? = myClass.init()
        
        parentController.addChildViewController(childController!)
        childController?.didMove(toParentViewController: parentController)
        return childController!
    }
    
    class func removeFromParentViewController(_ childContrller:UIViewController){
        childContrller.view.removeFromSuperview()
        
        childContrller.willMove(toParentViewController: nil)
        childContrller.removeFromParentViewController()
        
    }
    
    
    
    
    
    
    //MARK:
    //MARK:  第一次启动
    //MARK:
    class func isFirstLaunch(yes operationFirst:(()->())?,no operationElse:(()->())?)->Bool{
        let key="firstLaunch"
        let isFirstLaunc = !UserDefaults.standard.bool(forKey: key)
        
        if isFirstLaunc {
            if operationFirst != nil {
                operationFirst!()
            }
            
        }else{
            if operationElse != nil {
                operationElse!()
            }
        }
        
        return isFirstLaunc
    }
    private class func repeating(closure:(()->Void)?) ->DispatchSourceTimer{
        var count = 0
        let timer = DispatchSource.makeTimerSource(flags:.strict, queue:queue)
        //一次
        //        timer.scheduleOneshot(deadline: .now())
        
        timer.scheduleRepeating(deadline: .now(), interval: .seconds(1)
            /*, leeway: .milliseconds(100)*/)
        timer.setEventHandler {
            if closure != nil{
                closure!()
            }
            
            count += 1
            if count >= Int.max {
                timer.cancel()
            }
            
            
        }
        
        return timer
    }
    class func timerMethod(time total:Int,repeat repeatClosure:((Int)->Void)?,finish finishClosure:(()->Void)?)->DispatchSourceTimer{
        //定时器
        var tag=total
        var timer:DispatchSourceTimer!
        
        timer=LHUtility.repeating(closure: {
            LHUtility.mainQueue.async {
                guard tag>=0 else {
                    tag=total
                    timer?.cancel()
                    
                    
                    if finishClosure != nil {
                        finishClosure!()
                    }
                    return
                }
                if repeatClosure != nil {
                    repeatClosure!(tag)
                }
                tag-=1
                
                
                
            }
        })
        
        timer.resume()
        return timer
    }
    
    class func getCurrentData() -> String {
        let formatter=DateFormatter()
        formatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date.systemDate())
    }
    //MARK:
    //MARK:  日期转换
    //MARK:
    class func dateString(from date:Date) -> String {
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let string=dateFormatter.string(from: date)
        
        
        return string
    }
    
    class func date(from string:String)->Date{
        var dataS=string
        if string == "" {
            dataS=dateString(from: Date.systemDate())
        }
        
        
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        
        let date=dateFormatter.date(from: dataS)
        
        
        
        return date!
    }
    
     
}

//MARK:
//MARK:  通知NSNotificationCenter
//MARK:

extension LHUtility{
    class func post(Notification name:String){
        post(Notification: name, nil)
    }
    class func post(Notification name:String, _ object:Any?){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: object)
        
    }
    class func  removeNotification(_ observer: Any) {
        
        NotificationCenter.default.removeObserver(observer)
    }
    class func  addNotification(_ observer: Any, selector aSelector: Selector, name aName: String) {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: NSNotification.Name(rawValue: aName), object: nil)
    }
}

//MARK:
//MARK:  File 操作
//MARK:

extension LHUtility{
    
    class func fileExists(atPath path: String)->Bool{
        return FileManager.default.fileExists(atPath: path)
    }
    
    class func pathOfDirector(type:FileManager.SearchPathDirectory)->String{
        
        let paths=NSSearchPathForDirectoriesInDomains(type, .userDomainMask, true)
        
        let path=paths[0]+"/"
        return path
    }
    class func removeFile(atPath path:String)->Bool{
        if fileExists(atPath: path) {
            let isRemove:Bool?
            do {
                
                try FileManager.default.removeItem(atPath: path)
                isRemove=true
            } catch  {
                isRemove=false
            }
            return isRemove!
            
        }else{
            LLog(message: "此文件不存在")
            return false
        }
        
    }
    class func copyFile(atPath path:String,toPath dstPath:String)->Bool{
        
        do {
            try FileManager.default.copyItem(atPath: path, toPath: dstPath)
            return true
        } catch  {
            return false
        }
        
        
    }
    class func createDirectory(atPath path:String)->Bool{
        
        if !fileExists(atPath: path) {
            let isSuccesee:Bool?
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                isSuccesee=true
            } catch  {
                isSuccesee=false
            }
            return isSuccesee!
        }else{
            LLog(message: "此文件已经存在")
            return false
        }
    }
    
    class func contentsOfDirectory(atPath path:String)->[String]?{
        if fileExists(atPath: path) {
            let content:[String]?
            do {
                content = try FileManager.default.contentsOfDirectory(atPath: path)
            } catch  {
                content=nil
            }
            return content
        }else{
            return [String]()
        }
    }
    class func writeToFile(with data:Data,folderName:String,fileName:String)  {
        let rootPath=self.pathOfDirector(type: .cachesDirectory)
        
        let toPath=rootPath+folderName
        _=LHUtility.createDirectory(atPath: toPath)
        
        do {
            try data.write(to:URL(fileURLWithPath: toPath+"/"+fileName) , options: .atomic)
        } catch{
            LLog(message: "写入失败")
        }
        
        
    }
}


