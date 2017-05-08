//
//  LHGlobal.swift
//  GlassesSale
//
//  Created by LuoHao on 16/12/15.
//  Copyright © 2016 LuoHao. All rights reserved.
//

let ScreenWidth = UIScreen.main.bounds.width

let ScreenHeight = UIScreen.main.bounds.height

let iOS9 = (Float(UIDevice.current.systemVersion)!>=9.0)

let iOS10 = (Float(UIDevice.current.systemVersion)!>=10.0)

func LLog<T>(message: T...,
          file: String = #file,
          method: String = #function,
          line: Int = #line)
{
    
    
    #if DEBUG
        /*
         (message: T,
         file: String = #file,
         method: String = #function,
         line: Int = #line)
         
         print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
         */
        let fileName=file.components(separatedBy: "/").last!
        print("\(fileName) -> \(method)")
        for m in message {
            print(m)
        }
        print("\n")
    #endif
    
}

func registerNib(at tableView:UITableView,with nibName:String){
    
    let cellNib=UINib(nibName: nibName, bundle: nil)
    
    
    tableView.register(cellNib, forCellReuseIdentifier: nibName)
    
}
func registerClass(at tableView:UITableView,with className:String){
    
    tableView.register(stringClassFrom(className: className), forCellReuseIdentifier: className)
}


func currentVersion()->String {
    let current_Version=Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    return current_Version
}

func titleSize(by height:CGFloat) -> CGFloat {
    return height/1.2
}
func isFirstLaunchBy(key:String)->Bool{
    
    return !UserDefaults.standard.bool(forKey: key)
}

func stringClassFrom(className: String) -> AnyClass! {
    
    /// get namespace
    let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
    
    /// get 'anyClass' with classname and namespace
    let cls: AnyClass = NSClassFromString("\(namespace).\(className)")!;
    
    // return AnyClass!
    return cls;
}
