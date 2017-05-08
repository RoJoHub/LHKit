//
//  ChoosePositionViiew.swift
//  Glassmania
//
//  Created by LH-Mac on 2017/4/5.
//  Copyright © 2017年 LuoHao. All rights reserved.
//

import UIKit

class ChoosePositionController: BaseAlertController {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var adressListView: UITableView!
    @IBOutlet weak var containView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    let datas=standardListOfAddressModels()
    
    
    
    var finishClosure:(((provence:(index:Int,name:String),city:(index:Int,name:String),district:(index:Int,name:String)))->())!
    var selectedStates=(provence:(index:-1,name:""),city:(index:-1,name:""),district:(index:-1,name:""))
    enum PositionType :Int{
        case provence
        case city
        case district
    }
    
    var type: PositionType = .provence{
        didSet{
            
            self.titleLabel.text = type == .provence ? "省份选择":"区域选择"
            switch type {
            case .provence:
                
                currentDatas=datas
            case .city:
                
                currentDatas=datas[selectedStates.provence.index].cities
            case .district:
                currentDatas=datas[selectedStates.provence.index].cities[selectedStates.city.index].districts
            }
            guard currentDatas.count != 0 else {
                finishClosure(selectedStates)
                chooseFinish()
                return
            }
            backBtn.isHidden = (type == .provence) ? true:false
            adressListView.reloadData()
        }
    }
    var currentDatas: [Any]!
    
    let ide="AdressDetailCell"
    enum ActionType :Int{
        case back=1
        case cancel
        case ok
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        containView.corner(15)
        registerNib(at: adressListView, with: ide)
        adressListView.delegate=self
        adressListView.dataSource=self
        type = .provence
        adressListView.tableFooterView=UIView()
    }
    
    
    
    
    @IBAction func action(_ sender: UIButton) {
        let actionType=ActionType(rawValue: sender.tag)!
        
       
        
        switch actionType {
        case .back:
            
            let newType=PositionType(rawValue: type.rawValue-1)!
            type = newType
            var saveRow:Int!
            
            switch type {
            case .provence:
                saveRow=selectedStates.provence.index
            case .city:
                saveRow=selectedStates.city.index
            default:
                return
            }
            
            
            if saveRow != -1 {
                let newIndexPath=IndexPath(row: saveRow, section: 0)
                adressListView.selectRow(at: newIndexPath, animated: false, scrollPosition: .none)
            }
        case .cancel:
            chooseFinish()
        case .ok:
            guard let row=adressListView.indexPathForSelectedRow?.row as Int? else {
                LLog(message: "选择一个地区")
                return
            }
            
            switch type {
            case .provence:
                
                selectedStates.provence.index=row
                let provenceModel=currentDatas[row] as! ProvenceModel
                
                selectedStates.provence.name=provenceModel.p_name
                type = .city
            case .city:
                selectedStates.city.index=row
                let cityModel=currentDatas[row] as! CityModel
                
                selectedStates.city.name=cityModel.c_name
                type = .district
            case .district:
                selectedStates.district.index=row

                selectedStates.district.name=currentDatas[row] as! String
                
                finishClosure(selectedStates)
                chooseFinish()
            }
        }
    }
    func chooseFinish()  {
        LLog(message: "选择结束")
        
        self.dismiss(animated: false, completion: nil)
    }
}
extension ChoosePositionController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return currentDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell=tableView.dequeueReusableCell(withIdentifier: ide, for: indexPath) as! AdressDetailCell
        var name:String!
       
        
        
        switch type {
        case .provence:
            name=datas[indexPath.row].p_name
            
            
            
        case .city:
            let ds=currentDatas as! [CityModel]
            name=ds[indexPath.row].c_name
        case .district:
            let ds=currentDatas as! [String]
            name=ds[indexPath.row]
        }
        
        cell.positionName.text=name
        
        return cell
    }
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
