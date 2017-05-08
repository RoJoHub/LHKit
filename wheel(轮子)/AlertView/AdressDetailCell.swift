//
//  AdressDetailCell.swift
//  Glassmania
//
//  Created by LH-Mac on 2017/4/5.
//  Copyright © 2017年 LuoHao. All rights reserved.
//

import UIKit

class AdressDetailCell: UITableViewCell {

    @IBOutlet weak var positionName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor=BackgroundColor_TabOfMy
        self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        imgView.image = selected ? UIImage.pngFromBundle(with: "adress_s") : UIImage.pngFromBundle(with: "adress")
        
        // Configure the view for the selected state
    }
    
}
