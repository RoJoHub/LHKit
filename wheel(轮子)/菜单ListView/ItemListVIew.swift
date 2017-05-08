//
//  ItemListVIew.swift
//  Glassmania
//
//  Created by LH-Mac on 2017/3/30.
//  Copyright © 2017年 LuoHao. All rights reserved.
//

import UIKit

typealias Type_Titlt_ImageName = [(titlt:String,imageName:String)]

class ItemListVIew: UITableView {
    var action:((Int)->Void)!
    let ide="ItemCell"
    var data:Type_Titlt_ImageName!
    convenience init(lhframe: CGRect,type_Titlt_ImageName:Type_Titlt_ImageName) {
        
        self.init(frame: lhframe, style: .plain)
        self.isScrollEnabled=false
        self.delegate=self
        self.dataSource=self
        self.rowHeight=self.height/3
        self.data=type_Titlt_ImageName
        registerNib(at: self, with: ide)
    }
    

}
extension ItemListVIew:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell=tableView.dequeueReusableCell(withIdentifier: ide, for: indexPath) as! ItemCell
        let arg=data[indexPath.row]
        cell.titleLabel.text=arg.titlt
        cell.imgView.image=UIImage.pngFromBundle(with: arg.imageName)
        return cell
    }
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        action(indexPath.row)
        
    }
}
